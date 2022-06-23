import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
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

  String _videoDocPath(
          String? brand, String? model, String category, String name) =>
      "${_videoCollPath(brand, model, category)}/$name";

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
    final carInfo = await _getDocument(_carPath(brand, model))
        .snapshots()
        .asyncMap<CarInfo>(
      (event) async {
        final car = CarInfo.fromMap(await event.data()!);
        car.imagePath = "${car.brand}/${car.model}/${car.imagePath}";
        return car;
      },
    ).first;

    await _getCategories(carInfo);
    return carInfo;
  }

  Future<void> _getCategories(CarInfo carInfo) async {
    final path = _categoryCollPath(carInfo.brand, carInfo.model);
    final snapshots = await _getCollection(path).snapshots();
    final categories = await snapshots
        .asyncMap<List<CategoryInfo>>(
          (event) => Future.wait(
            event.docs.map((doc) {
              final snapshots = doc.reference.snapshots();
              return snapshots.asyncMap<CategoryInfo>(
                (event) async {
                  final data = await event.data()!;
                  final categorie = CategoryInfo.fromMap(data);
                  categorie.imagePath =
                      "${categorie.brand}/${categorie.model}/${categorie.name}/${categorie.imagePath}";
                  return categorie;
                },
              ).first;
            }).toList(),
          ),
        )
        .first;
    carInfo.categories.addAll(categories);
    await _getVideos(categories);
  }

  Future<void> _getVideos(List<CategoryInfo> categories) async {
    await Future.forEach<CategoryInfo>(categories, (category) async {
      final path =
          _videoCollPath(category.brand, category.model, category.name);
      final snapshots = await _getCollection(path).snapshots();
      final videos = await snapshots
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
      category.videos.addAll(videos);
    });
  }
}
