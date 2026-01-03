import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/favorites/domain/entities/favorite_cleaner.dart';

abstract class FavoritesRepository {
  ResultFuture<List<FavoriteCleaner>> getFavorites();
  ResultFuture<void> addFavorite(FavoriteCleaner favoriteCleaner);
  ResultFuture<void> removeFavorite(String cleanerId);
}
