import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:buzzy_bee/features/home/presentation/bloc/home_bloc.dart';
import 'package:buzzy_bee/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:buzzy_bee/core/bloc/language_cubit.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<HomeBloc>()..add(const RefreshHome()),
        ),
        BlocProvider(create: (context) => sl<BookingBloc>()),
        BlocProvider(
          create: (context) =>
              sl<WalletBloc>()..add(const WalletRefreshRequested()),
        ),
        BlocProvider(
          create: (context) => sl<AppBloc>()..add(const AppStarted()),
        ),
        BlocProvider(create: (context) => sl<LanguageCubit>()..loadLocale()),
      ],
      child: child,
    );
  }
}
