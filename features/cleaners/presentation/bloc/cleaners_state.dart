part of 'cleaners_bloc.dart';

enum CleanersStatus {
  initial,
  loading,
  success,
  error,
}

class CleanersState extends Equatable {
  final CleanersStatus status;
  final String? errorMessage;
  // Add your state properties here
  // final List<CleanersEntity>? items;

  const CleanersState({
    required this.status,
    this.errorMessage,
    // this.items,
  });

  const CleanersState.initial()
      : status = CleanersStatus.initial,
        errorMessage = null;
        // items = null;

  CleanersState copyWith({
    CleanersStatus? status,
    String? errorMessage,
    // List<CleanersEntity>? items,
  }) {
    return CleanersState(
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
