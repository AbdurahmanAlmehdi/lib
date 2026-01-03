import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/services/data/datasources/services_remote_data_source.dart';
import 'package:buzzy_bee/features/services/domain/repositories/services_repository.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource _remoteDataSource;

  ServicesRepositoryImpl(this._remoteDataSource);

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
  ResultFuture<Service?> getServiceById(String id) async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.getServiceById(id);
      },
      operationName: 'Get Service By ID',
    );
  }
}
