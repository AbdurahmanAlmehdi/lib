import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';

abstract class ServicesRepository {
  ResultFuture<List<Service>> getServices();
  ResultFuture<Service?> getServiceById(String id);
}
