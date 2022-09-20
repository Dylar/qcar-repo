import 'dart:async';

import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/video_info.dart';

abstract class CarInfoDataSource {
  Stream<List<CarInfo>> watchCarInfo();

  Future<void> addCarInfo(CarInfo info);

  Future<List<CarInfo>> getAllCars();

  Future<List<VideoInfo>> findVideos(String query);
}

class CarInfoDS implements CarInfoDataSource {
  CarInfoDS(this._database);

  final AppDatabase _database;

  final streamController = StreamController<List<CarInfo>>();

  void dispose() {
    streamController.close();
  }

  @override
  Future<void> addCarInfo(CarInfo note) async {
    await _database.upsertCarInfo(note);
    final list = await _database.getCarInfos();
    streamController.sink.add(list);
  }

  @override
  Future<List<CarInfo>> getAllCars() async {
    return _database.getCarInfos();
  }

  @override
  Stream<List<CarInfo>> watchCarInfo() {
    _database.getCarInfos().then((data) => streamController.add(data));
    return streamController.stream;
  }

  @override
  Future<List<VideoInfo>> findVideos(String query) async {
    final cars = await getAllCars();
    final lowerQuery = query.toLowerCase();
    final vids = <VideoInfo>[];
    cars.first.categories.forEach((cat) {
      if (cat.name.toLowerCase().contains(lowerQuery)) {
        vids.addAll(cat.videos);
      } else {
        cat.videos.forEach((vid) {
          final found = vid.name.toLowerCase().contains(lowerQuery) ||
              vid.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
          if (found) {
            vids.add(vid);
          }
        });
      }
    });
    return vids;
  }
}
