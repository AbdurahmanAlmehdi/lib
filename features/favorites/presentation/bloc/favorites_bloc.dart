import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:buzzy_bee/features/favorites/domain/entities/favorite_cleaner.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesBloc(this._repository) : super(const FavoritesState.initial()) {
    on<FavoritesLoadRequested>(_onLoadRequested);
    on<FavoriteAdded>(_onFavoriteAdded);
    on<FavoriteRemoved>(_onFavoriteRemoved);
  }

  Future<void> _onLoadRequested(
    FavoritesLoadRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    final result = await _repository.getFavorites();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (favorites) => emit(
        state.copyWith(status: FavoritesStatus.success, favorites: favorites),
      ),
    );
  }

  Future<void> _onFavoriteAdded(
    FavoriteAdded event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await _repository.addFavorite(event.favoriteCleaner);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        // Check if already exists to avoid duplicates
        final exists = state.favorites.any(
          (fav) => fav.cleaner.id == event.favoriteCleaner.cleaner.id,
        );
        if (!exists) {
          final updatedFavorites = [...state.favorites, event.favoriteCleaner];
          emit(state.copyWith(favorites: updatedFavorites));
        }
      },
    );
  }

  Future<void> _onFavoriteRemoved(
    FavoriteRemoved event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await _repository.removeFavorite(event.cleanerId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedFavorites = state.favorites
            .where((fav) => fav.cleaner.id != event.cleanerId)
            .toList();
        emit(state.copyWith(favorites: updatedFavorites));
      },
    );
  }
}
