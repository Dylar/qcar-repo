import 'package:qcar_business/core/models/seller_info.dart';

class InfoService {
  List<SellerInfo> getSeller() {
    return [
      SellerInfo(dealer: "Autohaus", name: "Maxi"),
      SellerInfo(dealer: "Autohaus", name: "Kolja"),
    ];
  }
}
