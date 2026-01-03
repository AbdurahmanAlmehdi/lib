import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/home/domain/repositories/home_repository.dart';
import 'package:buzzy_bee/features/home/domain/entities/ad_banner.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(const HomeState.initial()) {
    on<LoadBanners>(_onLoadBanners);
    on<LoadServices>(_onLoadServices);
    on<LoadPopularCleaners>(_onLoadPopularCleaners);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadBanners(
    LoadBanners event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _repository.getBanners();
    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (banners) => emit(state.copyWith(banners: banners)),
    );
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _repository.getServices();
    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (services) => emit(state.copyWith(services: services)),
    );
  }

  Future<void> _onLoadPopularCleaners(
    LoadPopularCleaners event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _repository.getPopularCleaners(limit: event.limit);
    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (cleaners) => emit(state.copyWith(popularCleaners: cleaners)),
    );
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.wait([
      _onLoadBanners(const LoadBanners(), emit),
      _onLoadServices(const LoadServices(), emit),
      _onLoadPopularCleaners(const LoadPopularCleaners(), emit),
    ]);
    emit(state.copyWith(status: HomeStatus.loaded));
  }
}
