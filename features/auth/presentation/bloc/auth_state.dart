import 'package:equatable/equatable.dart';

enum SubmissionStatus {
  idle,
  loading,
  success,
  registered,
  error;

  bool get isLoading => this == SubmissionStatus.loading;
  bool get isSuccess => this == SubmissionStatus.success;
  bool get isError => this == SubmissionStatus.error;
  bool get isRegistered => this == SubmissionStatus.registered;
}

class AuthState extends Equatable {
  final SubmissionStatus status;
  final String error;

  static const initial = AuthState(status: SubmissionStatus.idle, error: '');

  const AuthState({required this.status, required this.error});

  AuthState copyWith({
    SubmissionStatus? status,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
