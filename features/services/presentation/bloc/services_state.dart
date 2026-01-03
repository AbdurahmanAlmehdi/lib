part of 'services_bloc.dart';

enum ServicesStatus {
  initial,
  loading,
  success,
  error,
}

class ServicesState extends Equatable {
  final ServicesStatus status;
  final String? errorMessage;
  // Add your state properties here
  // final List<ServicesEntity>? items;

  const ServicesState({
    required this.status,
    this.errorMessage,
    // this.items,
  });

  const ServicesState.initial()
      : status = ServicesStatus.initial,
        errorMessage = null;
        // items = null;

  ServicesState copyWith({
    ServicesStatus? status,
    String? errorMessage,
    // List<ServicesEntity>? items,
  }) {
    return ServicesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      // items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        // items,
      ];
}
