import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:buzzy_bee/features/auth/domain/repositories/auth_repository.dart';
import 'package:buzzy_bee/features/auth/domain/entities/login_result.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<LoginResult> login({
    required String email,
    required String password,
  }) async {
    return await RepositoryHelper.execute(
      operation: () async {
        final model = await _remoteDataSource.login(
          email: email,
          password: password,
        );
        return model;
      },
      operationName: 'Login',
    );
  }

  @override
  ResultFuture<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return await RepositoryHelper.execute(
      operation: () async {
        await _remoteDataSource.register(
          name: name,
          phone: phone,
          email: email,
          password: password,
        );
      },
      operationName: 'Register',
    );
  }

  @override
  ResultFuture<User> getUser() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final model = await _remoteDataSource.getUser();
        return model;
      },
      operationName: 'Get User',
    );
  }
}
