part of 'orders_bloc.dart';

enum OrdersStatus {
  initial,
  loading,
  success,
  error,
}

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<Order> orders;
  final OrderFilter currentFilter;
  final String? errorMessage;

  const OrdersState({
    required this.status,
    this.orders = const [],
    this.currentFilter = OrderFilter.all,
    this.errorMessage,
  });

  const OrdersState.initial()
      : status = OrdersStatus.initial,
        orders = const [],
        currentFilter = OrderFilter.all,
        errorMessage = null;

  List<Order> get filteredOrders {
    if (currentFilter == OrderFilter.all) {
      return orders;
    }

    return orders.where((order) {
      switch (currentFilter) {
        case OrderFilter.inProgress:
          return order.status == BookingStatus.inProgress ||
              order.status == BookingStatus.confirmed ||
              order.status == BookingStatus.pending;
        case OrderFilter.completed:
          return order.status == BookingStatus.completed;
        case OrderFilter.cancelled:
          return order.status == BookingStatus.cancelled;
        case OrderFilter.all:
          return true;
      }
    }).toList();
  }

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    OrderFilter? currentFilter,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      currentFilter: currentFilter ?? this.currentFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        currentFilter,
        errorMessage,
      ];
}
