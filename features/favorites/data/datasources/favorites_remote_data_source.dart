import 'package:buzzy_bee/core/network/api_helper.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart';
import 'package:buzzy_bee/features/favorites/data/models/favorite_cleaner_model.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteCleanerModel>> getFavorites();
  Future<void> addFavorite(FavoriteCleanerModel favoriteCleaner);
  Future<void> removeFavorite(String cleanerId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final AppSupabaseClient _supabase;

  FavoritesRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<FavoriteCleanerModel>> getFavorites() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return [];
      }

      final response = await _supabase.database
          .from('favorites')
          .select('''
            *,
            cleaners!inner(*)
          ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      final favorites = <FavoriteCleanerModel>[];

      for (final item in data) {
        final cleanerData = item['cleaners'] as Map<String, dynamic>;
        final price = (item['price'] as num).toDouble();

        final servicesResponse = await _supabase.database
            .from('cleaner_services')
            .select('service_id')
            .eq('cleaner_id', cleanerData['id'] as String);

        final serviceIds =
            (servicesResponse as List<dynamic>?)
                ?.map((e) => e['service_id'] as String)
                .toList() ??
            [];

        final cleaner = CleanerModel.fromJson({
          ...cleanerData,
          'service_ids': serviceIds,
        });

        favorites.add(FavoriteCleanerModel(cleaner: cleaner));
      }

      return favorites;
    } catch (e) {
      throw ServerException('Failed to get favorites');
    }
  }

  @override
  Future<void> addFavorite(FavoriteCleanerModel favoriteCleaner) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await _supabase.database.from('favorites').insert({
        'user_id': user.id,
        'cleaner_id': favoriteCleaner.cleaner.id,
        'price': 0,
      });
    } catch (e) {
      throw ServerException('Failed to add favorite');
    }
  }

  @override
  Future<void> removeFavorite(String cleanerId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await _supabase.database
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('cleaner_id', cleanerId);
    } catch (e) {
      throw ServerException('Failed to remove favorite');
    }
  }
}
