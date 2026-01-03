import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/services/domain/repositories/services_repository.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _repository;

  ServicesBloc(this._repository) : super(const ServicesState.initial()) {
    on<ServicesLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    ServicesLoadRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(state.copyWith(status: ServicesStatus.loading));

    // TODO: Implement your business logic
    // Example:
    // final result = await _repository.getServicess();
    // result.fold(
    //   (failure) => emit(state.copyWith(
    //     status: ServicesStatus.error,
    //     errorMessage: failure.message,
    //   )),
    //   (data) => emit(state.copyWith(
    //     status: ServicesStatus.success,
    //     items: data,
    //   )),
    // );
  }
}
