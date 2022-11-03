import 'dart:async';

import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/models/favorite.dart';

abstract class FavoriteDataSource {
  Future<void> upsertFavorite(Favorite favorite);
  Future<void> deleteFavorite(Favorite favorite);

  Future<List<Favorite>> getFavorites(String brand, String model);

  Future<Favorite?> getFavorite(
      String brand, String model, String category, String video);

  Stream<List<Favorite>> watchFavorites();
}

class FavoriteDS implements FavoriteDataSource {
  FavoriteDS(this._database);

  final AppDatabase _database;

  final StreamController<List<Favorite>> _streamController = StreamController();

  @override
  Future<List<Favorite>> getFavorites(String brand, String model) async {
    return _database.getFavorites(brand, model);
  }

  @override
  Future<Favorite?> getFavorite(
      String brand, String model, String category, String video) {
    return _database.getFavorite(brand, model, category, video);
  }

  @override
  Future<void> upsertFavorite(Favorite favorite) async {
    await _database.upsertFavorite(favorite);
    _streamController.sink
        .add(await _database.getFavorites(favorite.brand, favorite.model));
  }

  @override
  Future<void> deleteFavorite(Favorite favorite) async {
    await _database.deleteFavorite(favorite);
    _streamController.sink
        .add(await _database.getFavorites(favorite.brand, favorite.model));
  }

  @override
  Stream<List<Favorite>> watchFavorites() async* {
    yield* _streamController.stream;
  }
}
