import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/search/domain/repositories/search_repository.dart';
import 'package:buzzy_bee/features/search/domain/entities/search_result.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;

  SearchBloc(this._repository) : super(const SearchState.initial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: restartable());
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(query: event.query));

    if (event.query.trim().isEmpty) {
      emit(state.copyWith(status: SearchStatus.initial, results: []));
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _repository.search(event.query);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (results) =>
          emit(state.copyWith(status: SearchStatus.success, results: results)),
    );
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchState.initial());
  }
}
