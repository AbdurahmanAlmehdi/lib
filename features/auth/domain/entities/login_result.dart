import 'package:equatable/equatable.dart';

class LoginResult extends Equatable {
  final String token;
  final String userId;

  const LoginResult({
    required this.token,
    required this.userId,
  });

  @override
  List<Object?> get props => [token, userId];
}

