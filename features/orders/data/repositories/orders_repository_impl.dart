import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:buzzy_bee/features/orders/domain/repositories/orders_repository.dart';
import 'package:buzzy_bee/features/orders/domain/entities/order.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<Order>> getOrders() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final models = await _remoteDataSource.getOrders();
        return models;
      },
      operationName: 'Get Orders',
    );
  }
}
