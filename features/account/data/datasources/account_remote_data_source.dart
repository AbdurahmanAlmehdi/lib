import 'package:buzzy_bee/core/network/api_helper.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart';
import 'package:buzzy_bee/features/account/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class AccountRemoteDataSource {
  Future<UserModel> getUser();
  Future<UserModel> updateUser(Map<String, dynamic> data);
  Future<void> deleteUser();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final AppSupabaseClient _supabase;

  AccountRemoteDataSourceImpl(this._supabase);

  @override
  Future<UserModel> getUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final response = await _supabase.database
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get user');
    }
  }

  @override
  Future<UserModel> updateUser(Map<String, dynamic> data) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final response = await _supabase.database
          .from('users')
          .update(data)
          .eq('id', user.id)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update user');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await _supabase.database.from('users').delete().eq('id', user.id);

      await _supabase.auth.signOut();
    } catch (e) {
      throw ServerException('Failed to delete user');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      // Verify current password by attempting to re-authenticate
      if (user.email == null) {
        throw ServerException('User email not found');
      }

      try {
        await _supabase.auth.signInWithPassword(
          email: user.email!,
          password: currentPassword,
        );
      } catch (e) {
        if (e.toString().contains('Invalid login credentials')) {
          throw ServerException('Current password is incorrect');
        }
        rethrow;
      }

      // Update password using Supabase Auth
      await _supabase.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to change password: ${e.toString()}');
    }
  }
}
