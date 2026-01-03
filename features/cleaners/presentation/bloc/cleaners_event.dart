part of 'cleaners_bloc.dart';

abstract class CleanersEvent extends Equatable {
  const CleanersEvent();

  @override
  List<Object?> get props => [];
}

class CleanersLoadRequested extends CleanersEvent {
  const CleanersLoadRequested();
}
