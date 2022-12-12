import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';

class InfoService {
  Map<String, List<SellInfo>> sellInfos = {};
  List<CarInfo> cars = [
    CarInfo(
      brand: "Opel",
      model: "Corsa",
      imagePath: "Toyota/CorollaTSGR/CorollaTSGR.jpg",
    ),
    CarInfo(
      brand: "Toyota",
      model: "Corolla",
      imagePath: "Toyota/CorollaTSGR/CorollaTSGR.jpg",
    ),
  ];
  List<VideoInfo> videos = [];

  List<VideoInfo> getVideos() {
    if (videos.isEmpty) {
      final car1 = cars.first;
      videos.add(VideoInfo(
        brand: car1.brand,
        model: car1.model,
        category: "Sicherheit",
        name: "Smart-Key, Keyless Go",
        categoryImagePath: "Toyota/CorollaTSGR/Sicherheit/Sicherheit.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Smart-Key, Keyless Go/Smart-Key, Keyless Go.jpg",
      ));
      videos.add(VideoInfo(
        brand: car1.brand,
        model: car1.model,
        category: "Sicherheit",
        name: "Gurt",
        categoryImagePath: "Toyota/CorollaTSGR/Sicherheit/Sicherheit.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Smart-Key, Keyless Go/Smart-Key, Keyless Go.jpg",
      ));

      videos.add(VideoInfo(
        brand: car1.brand,
        model: car1.model,
        category: "Räder & Reifen",
        name: "Reifenreparaturset",
        categoryImagePath: "Toyota/CorollaTSGR/Räder & Reifen/Reifen.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Räder & Reifen/reifenreparatur.jpg",
      ));

      final car2 = cars.last;
      videos.add(VideoInfo(
        brand: car2.brand,
        model: car2.model,
        category: "Sicherheit",
        name: "Rückfahrkamera",
        categoryImagePath: "Toyota/CorollaTSGR/Sicherheit/Sicherheit.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Rückfahrkamera/Rückfahrkamera.jpg",
      ));
    }
    return videos;
  }

  List<SellerInfo> getSeller() {
    return [
      SellerInfo(dealer: "Autohaus", name: "Maxi"),
      SellerInfo(dealer: "Autohaus", name: "Kolja"),
    ];
  }

  List<SellInfo> getSellInfos(SellerInfo sellerInfo) {
    return sellInfos[sellerInfo.name] ?? [];
  }

  void sellCar(SellInfo info) {
    final soldCars = sellInfos[info.seller.name] ?? [];
    soldCars.add(info);
    sellInfos[info.seller.name] = soldCars;
  }
}
