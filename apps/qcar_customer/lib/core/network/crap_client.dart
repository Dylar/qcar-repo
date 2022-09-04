import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/logger.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/schema_validator.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:ssh2/ssh2.dart';

const String CLIENT_CONNECTED = "sftp_connected";
const String CLIENT_DISCONNECTED = "sftp_disconnected";

enum FileType { UNKNOWN, JSON, VIDEO, IMAGE }

class CrapClient implements DownloadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  SSHClient? _client;

  String? _state;

  void _initClient() {
    _client = SSHClient(
      host: EnvironmentConfig.host,
      port: EnvironmentConfig.port,
      username: EnvironmentConfig.user,
      passwordOrKey: EnvironmentConfig.pewe,
    );
  }

  Future<String> _connect() async {
    try {
      _state = await _client?.connect();
      _state = await _client?.connectSFTP();
      Logger.logI("connect SFTP: $_state");
      return _state ?? "";
    } catch (e) {
      Logger.logE("${(e as PlatformException).message}", printTrace: true);
    }
    return "";
  }

  Future<String> _disconnect() async {
    _state = await _client?.disconnect();
    _state = await _client?.disconnectSFTP();
    Logger.logI("disconnect SFTP: $_state");
    return _state ?? "DAFUQ";
  }

  Future<List<FileData>> _getFileList({String path = "/"}) async {
    final dirs = await _client?.sftpLs(path);
    return dirs?.map<FileData>((json) {
          //Hint: its not real json ... so we need to parse shitty
          final splitFields = json.toString().split(",");
          Map<String, dynamic> infoMap = {};
          splitFields.forEach((element) {
            final splitKeyValue = element.split(":");
            final key = splitKeyValue.first;
            String value = "";
            for (int i = 1; i < splitKeyValue.length; i++) {
              if (value != "") {
                value += ":";
              }
              value += splitKeyValue[i];
            }
            infoMap[key.replaceAll("}", "").replaceAll("{", "").trim()] =
                value.replaceAll("}", "").replaceAll("{", "").trim();
          });
          return FileData.fromMap(infoMap);
        }).toList() ??
        [];
  }

  Future<DirData> _loadFileDir(DirData dir) async {
    try {
      List<FileData> initialFiles = await _getFileList(path: dir.path);
      initialFiles.forEach((file) {
        if (file.isDir) {
          if (!isForbidden(file.name)) {
            final path = dir.path + file.name + "/";
            dir.dirs.add(DirData(path));
          }
        } else {
          dir.files.add(file);
        }
      });

      //Hint: igitt - this is mäh
      if (dir.path.split("/").length == 5) {
        progressValue.value = Tuple(dir.dirs.length.toDouble(), 1);
      }

      if (dir.dirs.isNotEmpty) {
        await Future.forEach<DirData>(dir.dirs, (e) => _loadFileDir(e));
      }
    } catch (e) {
      Logger.logE("Path: ${dir.path}");
      Logger.logE("${e.toString()}");
    }

    //Hint: igitt - this is mäh
    if (dir.path.split("/").length == 6) {
      final oldValue = progressValue.value;
      progressValue.value = Tuple(oldValue.first, oldValue.secondOrThrow + 1);
    }

    return dir;
  }

  Future<DirData> _loadFilesData({String path = "/"}) async {
    _initClient();
    await _connect();
    final dirs = await _loadFileDir(DirData(path));
    _disconnect();
    return dirs;
  }

  Future<Response> loadCarInfo(SellInfo info) async {
    final brand = info.brand;
    final model = info.model;
    Logger.logI("Load car: $brand, $model");
    final carPath = "/Videos/$brand/$model/";
    final rootDir = await _loadFilesData(path: carPath);
    final jsonFile = rootDir.files.firstWhere(
      (file) => file.type == FileType.JSON,
    );
    final json = await _loadJsonFile(rootDir.path, jsonFile.name);
    final valid = await validateCarInfo(json);
    if (!valid) {
      throw Exception("Json invalid: $json");
    }
    final car = CarInfo.fromMap(json);
    car.categories.addAll(await _loadCategories(rootDir));
    _addDataPath(car.brand, car.model, "", car.categories);
    return Response.ok(jsonMap: car.toMap());
  }

  Future<List<CategoryInfo>> _loadCategories(DirData data) async {
    final allDirs = data.dirs.where((dir) => dir.files.any(
          (file) => file.type == FileType.JSON,
        ));
    return await Future.wait(allDirs.map((dir) async {
      final jsonFile = dir.files.firstWhere(
        (file) => file.type == FileType.JSON,
      );
      final json = await _loadJsonFile(dir.path, jsonFile.name);
      final valid = await validateCategoryInfo(json);
      if (!valid) {
        throw Exception("Category(${jsonFile.name}) json invalid: $json");
      }
      final category = CategoryInfo.fromMap(json);
      category.videos.addAll(await _loadVideos(dir));
      return category;
    }));
  }

  Future<List<VideoInfo>> _loadVideos(DirData data) async {
    final allDirs = data.dirs
        .where((dir) => dir.files.any((file) => file.type == FileType.JSON));
    return Future.wait(allDirs.map((dir) async {
      final jsonFile =
          dir.files.firstWhere((file) => file.type == FileType.JSON);
      final json = await _loadJsonFile(dir.path, jsonFile.name);
      final valid = await validateVideoInfo(json);
      if (!valid) {
        throw Exception("Video(${jsonFile.name}) json invalid: $json");
      }
      return VideoInfo.fromMap(json);
    }));
  }

  // void _printDirStruct(DirData dir) {
  //   print("DirPath: ${dir.path}");
  //   dir.dirs.forEach((dir) => _printDirStruct(dir));
  // }

  Future<Map<String, dynamic>> _loadJsonFile(
      String path, String fileName) async {
    HttpClient httpClient = new HttpClient();
    Map<String, dynamic> result = {};

    String theUrl = "";
    String rawJson = "";
    try {
      final url = "https://${EnvironmentConfig.domain}";
      theUrl = url + path + fileName;
      var request = await httpClient.getUrl(Uri.parse(theUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        rawJson = Utf8Decoder().convert(bytes);
        result = jsonDecode(rawJson);
      } else {
        throw Exception("Error code: " + response.statusCode.toString());
      }
    } catch (ex) {
      Logger.logE("Can not fetch url: $theUrl");
      Logger.logE(ex.toString());
      // throw Exception("Can not fetch url: $theUrl");
    }
    return result;
  }

  void _addDataPath(
      String brand, String model, String path, List<CategoryInfo> categories) {
    //TODO delete me if we got the urls right
    if (path == "") {
      path = "$brand/$model";
    }
    categories.forEach((category) {
      final catBasePath = "$path/${category.name}";
      category.imagePath = "$catBasePath/${category.imagePath}";
      category.videos.forEach((vid) {
        final vidBasePath = "$catBasePath/${vid.name}";
        vid.brand = brand;
        vid.model = model;
        vid.imagePath = "$vidBasePath/${vid.imagePath}";
        vid.filePath = "$vidBasePath/${vid.filePath}";
      });
    });
  }

  bool isForbidden(String name) {
    //TODO make new json struct
    final forbidden = [
      "Fahrzeugdaten",
      "Kraftstoff_Umwelt",
      "ZentralverriegelungmitschlüsselintegrierterFunkfernbedienungundBlinkderbestätigung/ZentralverriegelungmitschlüsselintegrierterFunkfernbedienungundBlinkderbestätigung"
    ].where((e) => e.toLowerCase().contains(name.toLowerCase())).isNotEmpty;
    return forbidden;
  }

  @override
  Future<Response> loadSellInfo(SellKey key) {
    throw UnimplementedError();
  }
}

class FileData {
  FileData(
    this.modificationDate,
    this.name,
    this.type,
    this.fileSize,
    this.isDir,
  );

  final String modificationDate, name;
  final FileType type;
  final int fileSize;
  final bool isDir;

  static FileData fromMap(Map<String, dynamic> map) {
    final String name = map["filename"] ?? "";
    final ext = name.split(".").last.toLowerCase();
    FileType type = FileType.UNKNOWN;
    if (["json", "txt"].contains(ext)) {
      type = FileType.JSON;
    } else if (["mp4"].contains(ext)) {
      type = FileType.VIDEO;
    } else if (["jpg", "jpeg", "png"].contains(ext)) {
      type = FileType.IMAGE;
    }
    return FileData(
      map["modificationDate"] ?? "",
      name,
      type,
      int.tryParse(map["fileSize"]) ?? 0,
      map["isDirectory"] == "true",
    );
  }
}

class DirData {
  DirData(this.path);

  final String path;
  final List<DirData> dirs = [];
  final List<FileData> files = [];
}
