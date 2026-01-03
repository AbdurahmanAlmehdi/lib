part of 'favorites_bloc.dart';

enum FavoritesStatus {
  initial,
  loading,
  success,
  error,
}

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteCleaner> favorites;
  final String? errorMessage;

  const FavoritesState({
    required this.status,
    this.favorites = const [],
    this.errorMessage,
  });

  const FavoritesState.initial()
      : status = FavoritesStatus.initial,
        favorites = const [],
        errorMessage = null;

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteCleaner>? favorites,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        favorites,
        errorMessage,
      ];
}
