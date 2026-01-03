import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/account/domain/repositories/account_repository.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _repository;
  final AppBloc _appBloc;

  AccountBloc(this._repository, this._appBloc)
    : super(const AccountState.initial()) {
    on<AccountLoadRequested>(_onLoadRequested);
    on<AccountUpdateRequested>(_onUpdateRequested);
    on<AccountLogoutRequested>(_onLogoutRequested);
    on<AccountDeleteRequested>(_onDeleteRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<UpdateAvatarRequested>(_onUpdateAvatarRequested);
  }

  Future<void> _onLoadRequested(
    AccountLoadRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await _repository.getUser();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(state.copyWith(status: AccountStatus.success, user: user)),
    );
  }

  Future<void> _onUpdateRequested(
    AccountUpdateRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final data = <String, dynamic>{
      'name': event.name,
      if (event.email != null) 'email': event.email,
      if (event.gender != null) 'gender': event.gender,
      if (event.phone != null) 'phone': event.phone,
    };

    final result = await _repository.updateUser(data);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) {
        emit(state.copyWith(status: AccountStatus.success, user: user));
        _appBloc.add(AppUserChanged(user));
      },
    );
  }

  Future<void> _onLogoutRequested(
    AccountLogoutRequested event,
    Emitter<AccountState> emit,
  ) async {
    _appBloc.add(const AppLoggedOut());
  }

  Future<void> _onDeleteRequested(
    AccountDeleteRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await _repository.deleteUser();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        _appBloc.add(const AppLoggedOut());
      },
    );
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await _repository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AccountStatus.success)),
    );
  }

  Future<void> _onUpdateAvatarRequested(
    UpdateAvatarRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    // Convert base64 to data URL format
    final avatarUrl = 'data:image/jpeg;base64,${event.avatarBase64}';

    final result = await _repository.updateUser({
      'avatar_url': avatarUrl,
    });

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) {
        emit(state.copyWith(status: AccountStatus.success, user: user));
        _appBloc.add(AppUserChanged(user));
      },
    );
  }
}
