part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersLoadRequested extends OrdersEvent {
  const OrdersLoadRequested();
}

class OrdersFilterChanged extends OrdersEvent {
  final OrderFilter filter;

  const OrdersFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
