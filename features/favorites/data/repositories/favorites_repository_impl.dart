import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:buzzy_bee/features/favorites/data/models/favorite_cleaner_model.dart';
import 'package:buzzy_bee/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:buzzy_bee/features/favorites/domain/entities/favorite_cleaner.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;

  FavoritesRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<FavoriteCleaner>> getFavorites() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final models = await _remoteDataSource.getFavorites();
        return models;
      },
      operationName: 'Get Favorites',
    );
  }

  @override
  ResultFuture<void> addFavorite(FavoriteCleaner favoriteCleaner) async {
    return await RepositoryHelper.execute(
      operation: () async {
        await _remoteDataSource.addFavorite(
          favoriteCleaner as FavoriteCleanerModel,
        );
      },
      operationName: 'Add Favorite',
    );
  }

  @override
  ResultFuture<void> removeFavorite(String cleanerId) async {
    return await RepositoryHelper.execute(
      operation: () async {
        await _remoteDataSource.removeFavorite(cleanerId);
      },
      operationName: 'Remove Favorite',
    );
  }
}
