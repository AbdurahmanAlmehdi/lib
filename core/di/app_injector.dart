import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:buzzy_bee/core/constants/api_constants.dart';
import 'package:buzzy_bee/core/network/api_interceptor.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart'
    show AppSupabaseClient;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/routes/app_router.dart';
import 'package:buzzy_bee/core/app_bloc/app_bloc.dart';
import 'package:buzzy_bee/features/home/data/datasources/home_remote_data_source.dart';
import 'package:buzzy_bee/features/home/data/repositories/home_repository_impl.dart';
import 'package:buzzy_bee/features/home/domain/repositories/home_repository.dart';
import 'package:buzzy_bee/features/home/presentation/bloc/home_bloc.dart';
import 'package:buzzy_bee/core/bloc/language_cubit.dart';
import 'package:buzzy_bee/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:buzzy_bee/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:buzzy_bee/features/orders/domain/repositories/orders_repository.dart';
import 'package:buzzy_bee/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:buzzy_bee/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:buzzy_bee/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:buzzy_bee/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:buzzy_bee/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:buzzy_bee/features/account/data/datasources/account_remote_data_source.dart';
import 'package:buzzy_bee/features/account/data/repositories/account_repository_impl.dart';
import 'package:buzzy_bee/features/account/domain/repositories/account_repository.dart';
import 'package:buzzy_bee/features/account/presentation/bloc/account_bloc.dart';
import 'package:buzzy_bee/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:buzzy_bee/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:buzzy_bee/features/auth/domain/repositories/auth_repository.dart';
import 'package:buzzy_bee/features/auth/presentation/cubit/login_cubit.dart';
import 'package:buzzy_bee/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:buzzy_bee/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:buzzy_bee/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:buzzy_bee/features/booking/domain/repositories/booking_repository.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:buzzy_bee/features/services/data/datasources/services_remote_data_source.dart';
import 'package:buzzy_bee/features/services/data/repositories/services_repository_impl.dart';
import 'package:buzzy_bee/features/services/domain/repositories/services_repository.dart';
import 'package:buzzy_bee/features/search/data/datasources/search_remote_data_source.dart';
import 'package:buzzy_bee/features/search/data/repositories/search_repository_impl.dart';
import 'package:buzzy_bee/features/search/domain/repositories/search_repository.dart';
import 'package:buzzy_bee/features/search/presentation/bloc/search_bloc.dart';
import 'package:buzzy_bee/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:buzzy_bee/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:buzzy_bee/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:buzzy_bee/features/wallet/presentation/bloc/wallet_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _registerCoreServices();
  _registerNetworkClients();
  _registerAppBloc();
  _registerLanguageCubit();
  _initRouter();
  _initHome();
  _initOrders();
  _initFavorites();
  _initAccount();
  _initAuth();
  _initBooking();
  _initSearch();
  _initWallet();
}

void _registerAppBloc() {
  sl.registerLazySingleton<AppBloc>(
    () => AppBloc(sl<FlutterSecureStorage>(), sl<AccountRepository>()),
  );
}

void _registerLanguageCubit() {
  sl.registerLazySingleton<LanguageCubit>(
    () => LanguageCubit(sl<FlutterSecureStorage>()),
  );
}

Future<void> _registerCoreServices() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  sl.registerLazySingleton<AppSupabaseClient>(() => AppSupabaseClient.instance);
}

void _registerNetworkClients() {
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(ApiInterceptor(sl<FlutterSecureStorage>()));

    return dio;
  }, instanceName: 'mainDio');
}

void _initRouter() {
  sl.registerLazySingleton<AppRouter>(() => AppRouter(sl<AppBloc>()));
  sl.registerLazySingleton<GoRouter>(() => sl<AppRouter>().router);
}

void _initHome() {
  sl.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(sl<AppSupabaseClient>()),
  );

  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(sl<ServicesRemoteDataSource>()),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      sl<AppSupabaseClient>().client,
      sl<ServicesRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<HomeRepository>()));
}

void _initOrders() {
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(sl<AppSupabaseClient>().client),
  );

  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sl<OrdersRemoteDataSource>()),
  );

  sl.registerFactory<OrdersBloc>(() => OrdersBloc(sl<OrdersRepository>()));
}

void _initFavorites() {
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(sl<AppSupabaseClient>()),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl<FavoritesRemoteDataSource>()),
  );

  sl.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(sl<FavoritesRepository>()),
  );
}

void _initAccount() {
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(sl<AppSupabaseClient>()),
  );

  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(sl<AccountRemoteDataSource>()),
  );

  sl.registerFactory<AccountBloc>(
    () => AccountBloc(sl<AccountRepository>(), sl<AppBloc>()),
  );
}

void _initAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<AppSupabaseClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      secureStorage: sl<FlutterSecureStorage>(),
      accountRepository: sl<AccountRepository>(),
      authRepository: sl<AuthRepository>(),
      appBloc: sl<AppBloc>(),
    ),
  );

  sl.registerFactory<SignupCubit>(
    () => SignupCubit(authRepository: sl<AuthRepository>()),
  );
}

void _initBooking() {
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(sl<AppSupabaseClient>()),
  );

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
  );

  sl.registerFactory<BookingBloc>(
    () => BookingBloc(sl<BookingRepository>(), sl<WalletRepository>()),
  );
}

void _initSearch() {
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl<AppSupabaseClient>().client),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl<SearchRemoteDataSource>()),
  );

  sl.registerFactory<SearchBloc>(() => SearchBloc(sl<SearchRepository>()));
}

void _initWallet() {
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(
      sl<AppSupabaseClient>(),
      sl<Dio>(instanceName: 'mainDio'),
    ),
  );

  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(sl<WalletRemoteDataSource>()),
  );

  sl.registerLazySingleton<WalletBloc>(
    () => WalletBloc(sl<WalletRepository>()),
  );
}

Future<void> resetDependencies() async {
  await sl.reset();
}
