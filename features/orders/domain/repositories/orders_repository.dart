import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/orders/domain/entities/order.dart';

abstract class OrdersRepository {
  ResultFuture<List<Order>> getOrders();
}
