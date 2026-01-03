import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart';

class AppSetup {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppSupabaseClient.initialize();

    _initSystemUI();
    await initDependencies();
  }

  static void _initSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }
}
