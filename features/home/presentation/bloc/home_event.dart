part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadBanners extends HomeEvent {
  const LoadBanners();
}

class LoadServices extends HomeEvent {
  const LoadServices();
}

class LoadPopularCleaners extends HomeEvent {
  final int limit;

  const LoadPopularCleaners({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}
