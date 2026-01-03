part of 'account_bloc.dart';

enum AccountStatus {
  initial,
  loading,
  success,
  error,
}

class AccountState extends Equatable {
  final AccountStatus status;
  final User? user;
  final String? errorMessage;

  const AccountState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AccountState.initial()
      : status = AccountStatus.initial,
        user = null,
        errorMessage = null;

  AccountState copyWith({
    AccountStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
      ];
}
