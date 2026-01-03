import 'package:bloc/bloc.dart';
import 'package:buzzy_bee/core/constants/storage_constants.dart';
import 'package:buzzy_bee/features/account/domain/repositories/account_repository.dart';
import 'package:buzzy_bee/features/auth/domain/repositories/auth_repository.dart';
import 'package:buzzy_bee/features/auth/presentation/bloc/auth_state.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final AccountRepository accountRepository;
  final AppBloc appBloc;
  final FlutterSecureStorage secureStorage;

  LoginCubit({
    required this.authRepository,
    required this.appBloc,
    required this.secureStorage,
    required this.accountRepository,
  }) : super(AuthState.initial);

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: SubmissionStatus.loading));
    final response = await authRepository.login(
      email: email,
      password: password,
    );
    response.fold(
      (failure) => emit(
        state.copyWith(status: SubmissionStatus.error, error: failure.message),
      ),
      (loginResult) async {
        await secureStorage.write(
          key: StorageConstants.accessToken,
          value: loginResult.token,
        );
        await secureStorage.write(
          key: StorageConstants.userId,
          value: loginResult.userId,
        );

        final result = await accountRepository.getUser();
        result.fold(
          (failure) {
            emit(
              state.copyWith(
                status: SubmissionStatus.error,
                error: failure.message,
              ),
            );
          },
          (user) {
            appBloc.add(AppUserChanged(user));
            emit(state.copyWith(status: SubmissionStatus.success));
          },
        );
      },
    );
  }
}
