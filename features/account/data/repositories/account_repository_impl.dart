import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/account/data/datasources/account_remote_data_source.dart';
import 'package:buzzy_bee/features/account/domain/repositories/account_repository.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;

  AccountRepositoryImpl(this._remoteDataSource);

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

  @override
  ResultFuture<User> updateUser(Map<String, dynamic> data) async {
    return await RepositoryHelper.execute(
      operation: () async {
        final model = await _remoteDataSource.updateUser(data);
        return model;
      },
      operationName: 'Update User',
    );
  }

  @override
  ResultFuture<void> deleteUser() async {
    return await RepositoryHelper.execute(
      operation: () async {
        await _remoteDataSource.deleteUser();
      },
      operationName: 'Delete User',
    );
  }

  @override
  ResultFuture<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await RepositoryHelper.execute(
      operation: () async {
        await _remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
      },
      operationName: 'Change Password',
    );
  }
}
