import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:buzzy_bee/features/home/data/models/ad_banner_model.dart';
import 'package:buzzy_bee/features/services/data/models/service_model.dart';
import 'package:buzzy_bee/features/services/data/datasources/services_remote_data_source.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<AdBannerModel>> getBanners();
  Future<List<ServiceModel>> getServices();
  Future<List<CleanerModel>> getPopularCleaners({int limit = 10});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient _client;
  final ServicesRemoteDataSource _servicesDataSource;

  HomeRemoteDataSourceImpl(this._client, this._servicesDataSource);

  @override
  Future<List<AdBannerModel>> getBanners() async {
    return [
      AdBannerModel(
        id: '1',
        imageUrl: 'https://via.placeholder.com/150',
        actionUrl: 'https://via.placeholder.com/150',
        actionType: 'https://via.placeholder.com/150',
        actionId: 'https://via.placeholder.com/150',
        priority: 1,
      ),
      AdBannerModel(
        id: '2',
        imageUrl: 'https://via.placeholder.com/150',
        actionUrl: 'https://via.placeholder.com/150',
        actionType: 'https://via.placeholder.com/150',
        actionId: 'https://via.placeholder.com/150',
        priority: 2,
      ),
    ];
  }

  @override
  Future<List<ServiceModel>> getServices() async {
    return await _servicesDataSource.getServices();
  }

  @override
  Future<List<CleanerModel>> getPopularCleaners({int limit = 10}) async {
    final response = await _client
        .from('cleaners')
        .select('*, cleaner_services(service_id)')
        .eq('is_active', true)
        .order('rating', ascending: false)
        .limit(limit);

    return (response as List<dynamic>)
        .map((e) => CleanerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
