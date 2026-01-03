import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:buzzy_bee/core/constants/storage_constants.dart';
import 'package:buzzy_bee/features/account/domain/repositories/account_repository.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';

part 'app_event.dart';
part 'app_state.dart';

/// App-level BLoC managing global application state
class AppBloc extends Bloc<AppEvent, AppState> {
  final FlutterSecureStorage _secureStorage;
  final AccountRepository _accountRepository;

  AppBloc(this._secureStorage, this._accountRepository)
    : super(const AppState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<AppUserChanged>(_onUserChanged);
    on<AppSetAuthData>(_onSetAuthData);
    on<AppLoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      final token = await _secureStorage.read(
        key: StorageConstants.accessToken,
      );
      final isAuthenticated = token != null && token.isNotEmpty;

      if (isAuthenticated) {
        final result = await _accountRepository.getUser();
        result.fold(
          (failure) {
            emit(const AppState.unauthenticated());
          },
          (user) {
            emit(AppState.authenticated(user));
          },
        );
      } else {
        emit(const AppState.unauthenticated());
      }
    } catch (e) {
      emit(const AppState.unauthenticated());
    }
  }

  Future<void> _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) async {
    emit(AppState.authenticated(event.user));
  }

  Future<void> _onSetAuthData(
    AppSetAuthData event,
    Emitter<AppState> emit,
  ) async {
    await _secureStorage.write(
      key: StorageConstants.accessToken,
      value: event.token,
    );
    await _secureStorage.write(
      key: StorageConstants.userId,
      value: event.userId,
    );

    final result = await _accountRepository.getUser();

    result.fold(
      (failure) {
        emit(const AppState.unauthenticated());
      },
      (user) {
        emit(AppState.authenticated(user));
      },
    );
  }


  Future<void> _onLoggedOut(AppLoggedOut event, Emitter<AppState> emit) async {
    await _secureStorage.delete(key: StorageConstants.accessToken);
    await _secureStorage.delete(key: StorageConstants.refreshToken);
    await _secureStorage.delete(key: StorageConstants.userId);

    emit(const AppState.unauthenticated());
  }
}
