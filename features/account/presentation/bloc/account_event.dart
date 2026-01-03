part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountLoadRequested extends AccountEvent {
  const AccountLoadRequested();
}

class AccountUpdateRequested extends AccountEvent {
  final String name;
  final String? email;
  final String? gender;
  final String? phone;

  const AccountUpdateRequested({
    required this.name,
    this.email,
    this.gender,
    this.phone,
  });

  @override
  List<Object?> get props => [name, email, gender, phone];
}

class AccountLogoutRequested extends AccountEvent {
  const AccountLogoutRequested();
}

class AccountDeleteRequested extends AccountEvent {
  const AccountDeleteRequested();
}

class ChangePasswordRequested extends AccountEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class UpdateAvatarRequested extends AccountEvent {
  final String avatarBase64;

  const UpdateAvatarRequested({required this.avatarBase64});

  @override
  List<Object?> get props => [avatarBase64];
}
