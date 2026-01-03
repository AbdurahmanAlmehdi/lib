import 'package:buzzy_bee/core/network/supabase_client.dart';
import 'package:buzzy_bee/features/auth/data/models/login_result_model.dart';
import 'package:buzzy_bee/features/account/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResultModel> login({
    required String email,
    required String password,
  });
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  Future<UserModel> getUser();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppSupabaseClient _supabase;

  AuthRemoteDataSourceImpl(this._supabase);

  @override
  Future<LoginResultModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: No user returned');
      }

      return LoginResultModel(
        token: response.session?.accessToken ?? '',
        userId: response.user!.id,
      );
    } catch (e) {
      if (e.toString().contains('Invalid login credentials')) {
        throw Exception('Invalid email or password');
      }
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'email': email,
        },
      );

      if (response.user == null) {
        throw Exception('Registration failed');
      }

      await _supabase.database
          .from('users')
          .update({
            'name': name,
            'phone': phone,
            'email': email,
          })
          .eq('id', response.user!.id);
    } catch (e) {
      if (e.toString().contains('User already registered')) {
        throw Exception('Email already registered');
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final response = await _supabase.database
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('No authenticated user');
    }
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
