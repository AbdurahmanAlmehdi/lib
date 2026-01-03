import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/core/app_setup.dart';
import 'package:buzzy_bee/core/app_providers.dart';
import 'package:buzzy_bee/core/theme/app_theme.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:buzzy_bee/core/bloc/language_cubit.dart';
import 'package:buzzy_bee/l10n/app_localizations.dart';

Future<void> main() async {
  await AppSetup.init();
  runApp(const AppProviders(child: BuzzyBeeApp()));
}

class BuzzyBeeApp extends StatelessWidget {
  const BuzzyBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          title: 'Buzzy Bee',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          darkTheme: AppTheme.darkTheme(context),
          themeMode: context.select<AppBloc, ThemeMode>(
            (bloc) => ThemeMode.light,
          ),
          routerConfig: sl<GoRouter>(),
          localizationsDelegates: [...AppLocalizations.localizationsDelegates],
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          locale: locale,
        );
      },
    );
  }
}
