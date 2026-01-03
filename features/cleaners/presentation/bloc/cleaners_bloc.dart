import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/cleaners/domain/repositories/cleaners_repository.dart';

part 'cleaners_event.dart';
part 'cleaners_state.dart';

class CleanersBloc extends Bloc<CleanersEvent, CleanersState> {
  final CleanersRepository _repository;

  CleanersBloc(this._repository) : super(const CleanersState.initial()) {
    on<CleanersLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    CleanersLoadRequested event,
    Emitter<CleanersState> emit,
  ) async {
    emit(state.copyWith(status: CleanersStatus.loading));

    // TODO: Implement your business logic
    // Example:
    // final result = await _repository.getCleanerss();
    // result.fold(
    //   (failure) => emit(state.copyWith(
    //     status: CleanersStatus.error,
    //     errorMessage: failure.message,
    //   )),
    //   (data) => emit(state.copyWith(
    //     status: CleanersStatus.success,
    //     items: data,
    //   )),
    // );
  }
}
