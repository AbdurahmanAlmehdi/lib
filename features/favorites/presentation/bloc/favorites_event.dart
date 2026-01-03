part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesLoadRequested extends FavoritesEvent {
  const FavoritesLoadRequested();
}

class FavoriteAdded extends FavoritesEvent {
  final FavoriteCleaner favoriteCleaner;

  const FavoriteAdded(this.favoriteCleaner);

  @override
  List<Object?> get props => [favoriteCleaner];
}

class FavoriteRemoved extends FavoritesEvent {
  final String cleanerId;

  const FavoriteRemoved(this.cleanerId);

  @override
  List<Object?> get props => [cleanerId];
}
