import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/auth/domain/entities/login_result.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';

abstract class AuthRepository {
  ResultFuture<LoginResult> login({
    required String email,
    required String password,
  });
  ResultFuture<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  ResultFuture<User> getUser();
}
