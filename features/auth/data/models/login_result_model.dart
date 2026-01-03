import 'package:buzzy_bee/features/auth/domain/entities/login_result.dart';

class LoginResultModel extends LoginResult {
  const LoginResultModel({
    required super.token,
    required super.userId,
  });

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      token: json['token'] as String,
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
    };
  }
}

