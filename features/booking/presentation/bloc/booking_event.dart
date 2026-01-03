part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class SelectDate extends BookingEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectTime extends BookingEvent {
  final String time;

  const SelectTime(this.time);

  @override
  List<Object?> get props => [time];
}

class SelectCleanerCount extends BookingEvent {
  final int count;

  const SelectCleanerCount(this.count);

  @override
  List<Object?> get props => [count];
}

class SelectCleaners extends BookingEvent {
  final List<String> cleanerIds;

  const SelectCleaners(this.cleanerIds);

  @override
  List<Object?> get props => [cleanerIds];
}

class SelectLocation extends BookingEvent {
  final Location location;

  const SelectLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class SelectPhoneNumber extends BookingEvent {
  final String phoneNumber;

  const SelectPhoneNumber(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SelectService extends BookingEvent {
  final Service service;

  const SelectService(this.service);

  @override
  List<Object?> get props => [service];
}

class LoadAvailableCleaners extends BookingEvent {
  const LoadAvailableCleaners();
}

class LoadAvailableCleanersCount extends BookingEvent {
  const LoadAvailableCleanersCount();
}

class ConfirmBooking extends BookingEvent {
  const ConfirmBooking();
}

class ResetBooking extends BookingEvent {
  const ResetBooking();
}

class LoadUserPhone extends BookingEvent {
  const LoadUserPhone();
}

class SetUseWallet extends BookingEvent {
  final bool useWallet;

  const SetUseWallet(this.useWallet);

  @override
  List<Object?> get props => [useWallet];
}
