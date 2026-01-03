part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<AdBanner> banners;
  final List<Service> services;
  final List<Cleaner> popularCleaners;
  final String? errorMessage;

  bool get isLoading =>
      status == HomeStatus.loading || status == HomeStatus.initial;

  const HomeState({
    required this.status,
    this.banners = const [],
    this.services = const [],
    this.popularCleaners = const [],
    this.errorMessage,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      banners = const [],
      services = const [],
      popularCleaners = const [],
      errorMessage = null;

  HomeState copyWith({
    HomeStatus? status,
    List<AdBanner>? banners,
    List<Service>? services,
    List<Cleaner>? popularCleaners,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      services: services ?? this.services,
      popularCleaners: popularCleaners ?? this.popularCleaners,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    banners,
    services,
    popularCleaners,
    errorMessage,
  ];
}
