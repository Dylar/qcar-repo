import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/Feedback.dart';
import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/model_data.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

const String BACKEND_V1 = "v1";

const bool TOGGLE_LOAD_EVERY = false;

class FirestoreClient implements DownloadClient, UploadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  DocumentReference<Map<String, dynamic>> _getDocument(String path) =>
      FirebaseFirestore.instance.doc(path);

  CollectionReference<Map<String, dynamic>> _getCollection(String path) =>
      FirebaseFirestore.instance.collection(path);

  String _carPath(String? brand, String? model) =>
      '$BACKEND_V1/car/$brand/$model';

  String _categoryCollPath(String? brand, String? model) =>
      "${_carPath(brand, model)}/category";

  String _categoryDocPath(String? brand, String? model, String category) =>
      "${_categoryCollPath(brand, model)}/$category";

  String _videoCollPath(String? brand, String? model, String category) =>
      "${_categoryDocPath(brand, model, category)}/video";

  String _videoDocPath(
          String? brand, String? model, String category, String name) =>
      "${_videoCollPath(brand, model, category)}/$name";

  String _introDocPath(
    String dealer,
    String seller,
    String? brand,
    String? model,
  ) =>
      "$BACKEND_V1/dealer/$dealer/$seller/intros/${brand}_${model}";

  Future<SellInfo> loadSellInfo(SellKey key) async {
    // final response = await NetworkService.sendRequest(
    //     requestType: RequestType.get, url: EnvironmentConfig.backendUrl);

    final sellInfo = await FirebaseFirestore.instance
        .collectionGroup("sales")
        .where("key", isEqualTo: key.key)
        .snapshots()
        .asyncMap((coll) => coll.docs.first)
        .asyncMap((doc) => doc.data())
        .asyncMap((map) => SellInfo.fromMap(map))
        .first;
    final introPath = _introDocPath(
        sellInfo.dealer, sellInfo.seller, sellInfo.brand, sellInfo.model);
    final intro = await _getDocument(introPath)
        .snapshots()
        .asyncMap<Map<String, dynamic>>((event) async => await event.data()!)
        .asyncMap<String>((map) async => map[FIELD_FILE_PATH])
        .first;
    return sellInfo
      ..introFilePath =
          "https://${EnvironmentConfig.domain}/videos/${sellInfo.brand}/${sellInfo.model}/${intro}";
  }

  Future<CarInfo> loadCarInfo(SellInfo info) async {
    try {
      if (TOGGLE_LOAD_EVERY) {
        return await _getCarDELETEME(info.brand, info.model);
      }
      return await _getCar(info);
    } catch (e) {
      print("error: ${e}");
      throw e;
    }
  }

  Future<CarInfo> _getCar(SellInfo info) async {
    final maxProgress = info.videos.length.toDouble();
    progressValue.value = Tuple(info.videos.length.toDouble(), 0);
    return await _getDocument(_carPath(info.brand, info.model))
        .snapshots()
        .asyncMap<Map<String, dynamic>>((event) async => await event.data()!)
        .asyncMap<CarInfo>((map) async => CarInfo.fromMap(map))
        .asyncMap<CarInfo>(
      (car) async {
        //TODO fix me in DB
        car.imagePath = "${car.brand}/${car.model}/${car.imagePath}";
        for (final catName in info.videos.keys) {
          final category = await _getCategory(info, catName);
          car.categories.add(category);
          for (final vidName in info.videos[catName]!) {
            final video = await _getVideo(info, catName, vidName);
            category.videos.add(video);
          }
          progressValue.value =
              Tuple(maxProgress, progressValue.value.secondOrThrow + 1);
        }

        return car;
      },
    ).first;
  }

  Future<CategoryInfo> _getCategory(SellInfo info, String category) async {
    final path = _categoryDocPath(info.brand, info.model, category);
    final snapshots = await _getDocument(path).snapshots();
    return await snapshots
        .asyncMap<Map<String, dynamic>>((event) async => await event.data()!)
        .asyncMap<CategoryInfo>((map) async => CategoryInfo.fromMap(map))
        .asyncMap<CategoryInfo>(
      (category) async {
        //TODO fix me in DB
        category.imagePath =
            "${category.brand}/${category.model}/${category.name}/${category.imagePath}";

        return category;
      },
    ).first;
  }

  Future<VideoInfo> _getVideo(
      SellInfo info, String category, String video) async {
    final path = _videoDocPath(info.brand, info.model, category, video);
    final snapshots = await _getDocument(path).snapshots();
    return await snapshots
        .asyncMap<Map<String, dynamic>>((event) async => await event.data()!)
        .asyncMap<VideoInfo>((map) async => VideoInfo.fromMap(map))
        .asyncMap<VideoInfo>(
      (video) async {
        //TODO fix me in DB
        video.filePath =
            "${video.brand}/${video.model}/${video.category}/${video.name}/${video.filePath}";
        video.imagePath =
            "${video.brand}/${video.model}/${video.category}/${video.name}/${video.imagePath}";
        return video;
      },
    ).first;
  }

  Future<CarInfo> _getCarDELETEME(String brand, String model) async {
    progressValue.value = Tuple(100, 0);
    return await _getDocument(_carPath(brand, model))
        .snapshots()
        .asyncMap<CarInfo>(
      (event) async {
        final car = CarInfo.fromMap(await event.data()!);
        car.imagePath = "${car.brand}/${car.model}/${car.imagePath}";
        car.categories.addAll(await _getCategoriesDELETEME(car));
        return car;
      },
    ).first;
  }

  Future<List<CategoryInfo>> _getCategoriesDELETEME(CarInfo carInfo) async {
    final path = _categoryCollPath(carInfo.brand, carInfo.model);
    final snapshots = await _getCollection(path).snapshots();
    return await snapshots.asyncMap<List<CategoryInfo>>(
      (event) {
        final docs = event.docs;
        final maxProgress = docs.length.toDouble();
        progressValue.value = Tuple(maxProgress, 1);
        return Future.wait(
          docs.map((doc) {
            final snapshots = doc.reference.snapshots();
            return snapshots.asyncMap<CategoryInfo>(
              (event) async {
                final data = await event.data()!;
                final category = CategoryInfo.fromMap(data);
                category.videos.addAll(await _getVideosDELETEME(category));
                //TODO fix path
                category.imagePath =
                    "${category.brand}/${category.model}/${category.name}/${category.imagePath}";

                progressValue.value =
                    Tuple(maxProgress, progressValue.value.secondOrThrow + 1);
                return category;
              },
            ).first;
          }).toList(),
        );
      },
    ).first;
  }

  Future<List<VideoInfo>> _getVideosDELETEME(CategoryInfo category) async {
    final path = _videoCollPath(category.brand, category.model, category.name);
    final snapshots = await _getCollection(path).snapshots();
    return await snapshots
        .asyncMap<List<VideoInfo>>(
          (event) => Future.wait(
            event.docs.map((doc) {
              final snapshots = doc.reference.snapshots();
              return snapshots.asyncMap<VideoInfo>(
                (event) async {
                  final data = await event.data()!;
                  final video = VideoInfo.fromMap(data);
                  //TODO fix path
                  video.filePath =
                      "${video.brand}/${video.model}/${video.category}/${video.name}/${video.filePath}";
                  video.imagePath =
                      "${video.brand}/${video.model}/${video.category}/${video.name}/${video.imagePath}";
                  return video;
                },
              ).first;
            }).toList(),
          ),
        )
        .first;
  }

  @override
  Future sendFeedback(Feedback feedback) {
    // TODO: implement sendFeedback
    throw UnimplementedError();
  }

  @override
  Future sendTracking(Tracking tracking) {
    // TODO: implement sendTracking
    throw UnimplementedError();
  }
}
