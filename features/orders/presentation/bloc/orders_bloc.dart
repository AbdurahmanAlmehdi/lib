import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/orders/domain/repositories/orders_repository.dart';
import 'package:buzzy_bee/features/orders/domain/entities/order.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _repository;

  OrdersBloc(this._repository) : super(const OrdersState.initial()) {
    on<OrdersLoadRequested>(_onLoadRequested);
    on<OrdersFilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadRequested(
    OrdersLoadRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    final result = await _repository.getOrders();

    result.fold(
      (failure) => emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: failure.message,
      )),
      (orders) => emit(state.copyWith(
        status: OrdersStatus.success,
        orders: orders,
      )),
    );
  }

  void _onFilterChanged(
    OrdersFilterChanged event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(currentFilter: event.filter));
  }
}
