import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:buzzy_bee/core/constants/storage_constants.dart';

class LanguageCubit extends Cubit<Locale> {
  final FlutterSecureStorage _storage;

  LanguageCubit(this._storage) : super(const Locale('ar')) {
    loadLocale();
  }

  Future<void> setLanguage(String code) async {
    await _storage.write(key: StorageConstants.locale, value: code);
    emit(Locale(code));
  }

  Future<void> loadLocale() async {
    final storedLocale =
        await _storage.read(key: StorageConstants.locale) ?? 'ar';
    emit(Locale(storedLocale));
  }
}

