part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the app starts
class AppStarted extends AppEvent {
  const AppStarted();
}

/// Event triggered when user authentication changes
class AppUserChanged extends AppEvent {
  final User user;

  const AppUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Event triggered when auth data is set (after login)
class AppSetAuthData extends AppEvent {
  final String token;
  final String userId;

  const AppSetAuthData({required this.token, required this.userId});

  @override
  List<Object?> get props => [token, userId];
}

/// Event triggered when user logs out
class AppLoggedOut extends AppEvent {
  const AppLoggedOut();
}
