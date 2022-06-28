import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

const String BACKEND_V1 = "v1";

class FirestoreClient implements LoadClient {
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

  // String _videoDocPath(
  //         String? brand, String? model, String category, String name) =>
  //     "${_videoCollPath(brand, model, category)}/$name";

  Future<SellInfo> loadSellInfo(SellKey key) async {
    // final response = await NetworkService.sendRequest(
    //     requestType: RequestType.get, url: EnvironmentConfig.backendUrl);

    return await FirebaseFirestore.instance
        .collectionGroup("sales")
        .where("key", isEqualTo: key.key)
        .snapshots()
        .asyncMap((coll) => coll.docs.first)
        .asyncMap((doc) => doc.data())
        .asyncMap((map) => SellInfo.fromMap(map))
        .first;
  }

  Future<CarInfo> loadCarInfo(String? brand, String? model) async {
    // FirebaseFirestore.instance.doc(BACKEND_V1).get()
    brand = "Toyota";
    model = "CorollaTSGR";
    try {
      return await _getCar(brand, model);
    } catch (e) {
      print("error: ${e}");
      throw e;
    }
  }

  Future<CarInfo> _getCar(String brand, String model) async {
    progressValue.value = Tuple(100, 0);
    return await _getDocument(_carPath(brand, model))
        .snapshots()
        .asyncMap<CarInfo>(
      (event) async {
        final car = CarInfo.fromMap(await event.data()!);
        car.imagePath = "${car.brand}/${car.model}/${car.imagePath}";
        car.categories.addAll(await _getCategories(car));
        return car;
      },
    ).first;
  }

  Future<List<CategoryInfo>> _getCategories(CarInfo carInfo) async {
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
                category.videos.addAll(await _getVideos(category));
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

  Future<List<VideoInfo>> _getVideos(CategoryInfo category) async {
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
}
