import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/home/data/datasources/home_remote_data_source.dart';
import 'package:buzzy_bee/features/home/domain/repositories/home_repository.dart';
import 'package:buzzy_bee/features/home/domain/entities/ad_banner.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<AdBanner>> getBanners() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final models = await _remoteDataSource.getBanners();
        return models.where((banner) => !banner.isExpired).toList();
      },
      operationName: 'Get Banners',
    );
  }

  @override
  ResultFuture<List<Service>> getServices() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final models = await _remoteDataSource.getServices();
        return models..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      },
      operationName: 'Get Services',
    );
  }

  @override
  ResultFuture<List<Cleaner>> getPopularCleaners({int limit = 10}) async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.getPopularCleaners(limit: limit);
      },
      operationName: 'Get Popular Cleaners',
    );
  }
}
