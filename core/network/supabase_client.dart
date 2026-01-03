import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AppSupabaseClient {
  static AppSupabaseClient? _instance;
  static AppSupabaseClient get instance {
    if (_instance == null) {
      throw Exception(
        'AppSupabaseClient not initialized. Call AppSupabaseClient.initialize() first.',
      );
    }
    return _instance!;
  }

  late final supabase.Supabase _supabase;
  AppSupabaseClient._();

  static Future<void> initialize() async {
    if (_instance != null) {
      return;
    }

    _instance = AppSupabaseClient._();

    await supabase.Supabase.initialize(
      url: 'https://izofjbartukmveyfzmpf.supabase.co',
      anonKey: 'sb_publishable_QrYqFHCrgm9P0ms4P8ZuQw_KeE--v_T',
      debug: true,
    );

    _instance!._supabase = supabase.Supabase.instance;
  }

  supabase.SupabaseClient get client => _supabase.client;

  supabase.GoTrueClient get auth => _supabase.client.auth;

  supabase.PostgrestClient get database => _supabase.client.rest;
}
