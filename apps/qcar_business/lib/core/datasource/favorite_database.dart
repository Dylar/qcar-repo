import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/models/favorite.dart';

abstract class FavoriteDatabase {
  Future<void> upsertFavorite(Favorite favorite);

  Future<void> deleteFavorite(Favorite favorite);

  Future<List<Favorite>> getFavorites(String brand, String model);

  Future<Favorite?> getFavorite(
      String brand, String model, String category, String video);
}

mixin FavoriteDB implements FavoriteDatabase {
  Box<Favorite> get favoriteBox => Hive.box<Favorite>(BOX_FAVORITE);

  @override
  Future<void> upsertFavorite(Favorite favorite) async {
    await favoriteBox.put(
      favorite.brand + favorite.model + favorite.category + favorite.video,
      favorite,
    );
  }

  @override
  Future<void> deleteFavorite(Favorite favorite) async {
    await favoriteBox.delete(
      favorite.brand + favorite.model + favorite.category + favorite.video,
    );
  }

  @override
  Future<List<Favorite>> getFavorites(String brand, String model) async {
    return favoriteBox.values
        .where((fav) => fav.brand == brand && fav.model == model)
        .toList();
  }

  @override
  Future<Favorite?> getFavorite(
      String brand, String model, String category, String video) async {
    return favoriteBox.get(brand + model + category + video);
  }
}
