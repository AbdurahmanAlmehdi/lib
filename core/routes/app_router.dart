import 'dart:async';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/features/account/presentation/bloc/account_bloc.dart';
import 'package:buzzy_bee/features/account/presentation/screens/account_screen.dart';
import 'package:buzzy_bee/features/account/presentation/screens/about_screen.dart';
import 'package:buzzy_bee/features/account/presentation/screens/faq_screen.dart';
import 'package:buzzy_bee/features/account/presentation/screens/contact_us_screen.dart';
import 'package:buzzy_bee/features/account/presentation/screens/change_password_screen.dart';
import 'package:buzzy_bee/features/account/presentation/screens/change_phone_screen.dart';
import 'package:buzzy_bee/features/account/presentation/screens/personal_account_screen.dart';
import 'package:buzzy_bee/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:buzzy_bee/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:buzzy_bee/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:buzzy_bee/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:buzzy_bee/features/orders/presentation/screens/orders_screen.dart';
import 'package:buzzy_bee/core/splash/splash_screen.dart';
import 'package:buzzy_bee/features/auth/presentation/screens/welcome_screen.dart';
import 'package:buzzy_bee/features/auth/presentation/screens/login_screen.dart';
import 'package:buzzy_bee/features/auth/presentation/screens/signup_screen.dart';
import 'package:buzzy_bee/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:buzzy_bee/features/location/presentation/screens/location_picker_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/booking_screen.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/date_time_selection_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/cleaner_count_selection_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/cleaner_selection_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/booking_location_selection_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/phone_input_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:buzzy_bee/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:buzzy_bee/features/main/presentation/screens/main_screen.dart';
import 'package:buzzy_bee/features/home/presentation/screens/home_screen.dart';
import 'package:buzzy_bee/features/home/presentation/screens/search_screen.dart';
import 'package:buzzy_bee/features/search/presentation/bloc/search_bloc.dart';
import 'package:buzzy_bee/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:buzzy_bee/features/wallet/presentation/screens/moamalat_webview_screen.dart';
import 'package:buzzy_bee/features/wallet/presentation/bloc/wallet_bloc.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  const AppRouter(this.appBloc);

  final AppBloc appBloc;

  GoRouter get router => GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.welcome,
        name: AppRouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRouteNames.register,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<SignupCubit>(),
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: AppRouteNames.search,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<SearchBloc>(),
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.locationPicker,
        name: AppRouteNames.locationPicker,
        builder: (context, state) => const LocationPickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.booking,
        name: AppRouteNames.booking,
        builder: (context, state) {
          final service = state.extra as Service?;

          if (service == null) {
            Future.microtask(() {
              if (context.mounted) {
                context.go(AppRoutes.home);
              }
            });
            // Return a placeholder while redirecting
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            context.read<BookingBloc>().add(SelectService(service));
          }
          return const BookingScreen();
        },
        routes: [
          GoRoute(
            path: AppRoutes.dateTimeSelection,
            name: AppRouteNames.dateTimeSelection,
            builder: (context, state) {
              return const DateTimeSelectionScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.cleanerCountSelection,
            name: AppRouteNames.cleanerCountSelection,
            builder: (context, state) {
              return const CleanerCountSelectionScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.cleanerSelection,
            name: AppRouteNames.cleanerSelection,
            builder: (context, state) {
              return const CleanerSelectionScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.bookingLocationSelection,
            name: AppRouteNames.bookingLocationSelection,
            builder: (context, state) {
              return const BookingLocationSelectionScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.phoneInput,
            name: AppRouteNames.phoneInput,
            builder: (context, state) {
              context.read<WalletBloc>().add(const WalletRefreshRequested());
              return const PhoneInputScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.bookingConfirmation,
            name: AppRouteNames.bookingConfirmation,
            builder: (context, state) {
              return const BookingConfirmationScreen();
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.about,
        name: AppRouteNames.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        name: AppRouteNames.faq,
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: AppRoutes.contactUs,
        name: AppRouteNames.contactUs,
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: AppRouteNames.changePassword,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AccountBloc>(),
          child: const ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.changePhone,
        name: AppRouteNames.changePhone,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AccountBloc>(),
          child: const ChangePhoneScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.personalAccount,
        name: AppRouteNames.personalAccount,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AccountBloc>(),
          child: const PersonalAccountScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.wallet,
        name: AppRouteNames.wallet,
        builder: (context, state) {
          context.read<WalletBloc>().add(const WalletRefreshRequested());
          return const WalletScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.moamalatWebview,
        name: AppRouteNames.moamalatWebview,
        builder: (context, state) {
          final paymentUrl = state.extra as String?;
          if (paymentUrl == null) {
            Future.microtask(() {
              if (context.mounted) {
                context.pop();
              }
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return MoamalatWebViewScreen(paymentUrl: paymentUrl);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider(
            create: (context) =>
                sl<FavoritesBloc>()..add(const FavoritesLoadRequested()),
            child: MainScreen(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRouteNames.home,
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<HomeBloc>()..add(const RefreshHome()),
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                name: AppRouteNames.orders,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      sl<OrdersBloc>()..add(const OrdersLoadRequested()),
                  child: const OrdersScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                name: AppRouteNames.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                name: AppRouteNames.account,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      sl<AccountBloc>()..add(const AccountLoadRequested()),
                  child: const AccountScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final appState = appBloc.state;
      final location = state.matchedLocation;

      final isSplashRoute = location == AppRoutes.splash;
      final isWelcomeRoute = location == AppRoutes.welcome;
      final isAuthRoute =
          location == AppRoutes.login || location == AppRoutes.register;

      if (appState.status == AppStatus.initial ||
          appState.status == AppStatus.loading) {
        return isSplashRoute ? null : AppRoutes.splash;
      }

      if (appState.status == AppStatus.unauthenticated) {
        if (isSplashRoute) {
          return AppRoutes.welcome;
        }
        if (isAuthRoute || isWelcomeRoute) {
          return null;
        }
        return AppRoutes.welcome;
      }

      if (appState.status == AppStatus.authenticated) {
        if (isSplashRoute || isWelcomeRoute || isAuthRoute) {
          return AppRoutes.home;
        }
        return null;
      }

      return null;
    },
    refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}

class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    // Initial notification to trigger redirect check
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      debugPrint(
        'GoRouterAppBlocRefreshStream: AppState changed to ${appState.status}',
      );
      // Notify GoRouter to re-evaluate redirect
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
