import 'package:bloc/bloc.dart';
import 'package:buzzy_bee/features/auth/domain/repositories/auth_repository.dart';
import 'package:buzzy_bee/features/auth/presentation/bloc/auth_state.dart';

class SignupCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  SignupCubit({required this.authRepository}) : super(AuthState.initial);

  Future<void> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: SubmissionStatus.loading));
    final response = await authRepository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
    response.fold(
      (failure) => emit(
        state.copyWith(status: SubmissionStatus.error, error: failure.message),
      ),
      (_) async {
        emit(state.copyWith(status: SubmissionStatus.registered));
      },
    );
  }
}
