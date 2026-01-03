part of 'booking_bloc.dart';

enum BookingFlowStatus {
  initial,
  dateSelected,
  countSelected,
  cleanersSelected,
  locationSelected,
  confirming,
  success,
  error,
}

class BookingState extends Equatable {
  final BookingFlowStatus status;
  final Service? service;
  final DateTime? selectedDate;
  final String? selectedTime;
  final int? cleanerCount;
  final int? maxAvailableCleaners;
  final String? serviceId;
  final String? serviceTitle;
  final String? phoneNumber;
  final List<String> selectedCleanerIds;
  final Location? selectedLocation;
  final List<Cleaner> availableCleaners;
  final Booking? confirmedBooking;
  final String? errorMessage;
  final bool useWallet;
  final bool isLoadingCleanerCount;

  const BookingState({
    required this.status,
    this.service,
    this.selectedDate,
    this.selectedTime,
    this.cleanerCount,
    this.maxAvailableCleaners,
    this.serviceId,
    this.serviceTitle,
    this.phoneNumber,
    this.selectedCleanerIds = const [],
    this.selectedLocation,
    this.availableCleaners = const [],
    this.confirmedBooking,
    this.errorMessage,
    this.useWallet = false,
    this.isLoadingCleanerCount = false,
  });

  const BookingState.initial()
    : status = BookingFlowStatus.initial,
      service = null,
      selectedDate = null,
      selectedTime = null,
      cleanerCount = null,
      maxAvailableCleaners = null,
      serviceId = null,
      serviceTitle = null,
      phoneNumber = null,
      selectedCleanerIds = const [],
      selectedLocation = null,
      availableCleaners = const [],
      confirmedBooking = null,
      errorMessage = null,
      useWallet = false,
      isLoadingCleanerCount = false;

  BookingState copyWith({
    BookingFlowStatus? status,
    Service? service,
    DateTime? selectedDate,
    String? selectedTime,
    int? cleanerCount,
    int? maxAvailableCleaners,
    String? serviceId,
    String? serviceTitle,
    String? phoneNumber,
    List<String>? selectedCleanerIds,
    Location? selectedLocation,
    List<Cleaner>? availableCleaners,
    Booking? confirmedBooking,
    String? errorMessage,
    bool? useWallet,
    bool? isLoadingCleanerCount,
  }) {
    return BookingState(
      status: status ?? this.status,
      service: service ?? this.service,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      cleanerCount: cleanerCount ?? this.cleanerCount,
      maxAvailableCleaners: maxAvailableCleaners ?? this.maxAvailableCleaners,
      serviceId: serviceId ?? this.serviceId,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedCleanerIds: selectedCleanerIds ?? this.selectedCleanerIds,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      availableCleaners: availableCleaners ?? this.availableCleaners,
      confirmedBooking: confirmedBooking ?? this.confirmedBooking,
      errorMessage: errorMessage ?? this.errorMessage,
      useWallet: useWallet ?? this.useWallet,
      isLoadingCleanerCount:
          isLoadingCleanerCount ?? this.isLoadingCleanerCount,
    );
  }

  bool get canProceedToCleaners =>
      selectedDate != null && cleanerCount != null && serviceId != null;

  bool get canProceedToLocation =>
      canProceedToCleaners && selectedCleanerIds.length == (cleanerCount ?? 0);

  bool get canConfirm => canProceedToLocation && selectedLocation != null;

  @override
  List<Object?> get props => [
    status,
    service,
    selectedDate,
    selectedTime,
    cleanerCount,
    maxAvailableCleaners,
    serviceId,
    serviceTitle,
    phoneNumber,
    selectedCleanerIds,
    selectedLocation,
    availableCleaners,
    confirmedBooking,
    errorMessage,
    useWallet,
    isLoadingCleanerCount,
  ];
}
