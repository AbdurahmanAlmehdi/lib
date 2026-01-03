part of 'app_bloc.dart';

enum AppStatus { initial, loading, authenticated, unauthenticated, error }

class AppState extends Equatable {
  final AppStatus status;
  final bool isAuthenticated;
  final User user;

  const AppState({
    required this.status,
    this.isAuthenticated = false,
    this.user = User.anonymous,
  });

  const AppState.initial()
    : status = AppStatus.initial,
      isAuthenticated = false,
      user = User.anonymous;

  const AppState.authenticated(User user)
    : status = AppStatus.authenticated,
      isAuthenticated = true,
      user = user;

  const AppState.unauthenticated({User? user})
    : status = AppStatus.unauthenticated,
      isAuthenticated = false,
      user = user ?? User.anonymous;

  AppState copyWith({AppStatus? status, bool? isAuthenticated, User? user}) {
    return AppState(
      status: status ?? this.status,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, isAuthenticated, user];
}
