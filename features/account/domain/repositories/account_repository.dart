import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/account/domain/entities/user.dart';

abstract class AccountRepository {
  ResultFuture<User> getUser();
  ResultFuture<User> updateUser(Map<String, dynamic> data);
  ResultFuture<void> deleteUser();
  ResultFuture<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
