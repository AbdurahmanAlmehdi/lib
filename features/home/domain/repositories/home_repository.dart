import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/home/domain/entities/ad_banner.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

abstract class HomeRepository {
  ResultFuture<List<AdBanner>> getBanners();
  ResultFuture<List<Service>> getServices();
  ResultFuture<List<Cleaner>> getPopularCleaners({int limit = 10});
}
