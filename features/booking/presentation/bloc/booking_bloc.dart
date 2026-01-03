import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/booking/domain/repositories/booking_repository.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';
import 'package:buzzy_bee/features/booking/domain/entities/location.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/features/booking/data/models/booking_model.dart';
import 'package:buzzy_bee/features/wallet/domain/repositories/wallet_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;
  final WalletRepository? _walletRepository;

  BookingBloc(this._repository, [this._walletRepository])
    : super(const BookingState.initial()) {
    on<SelectService>(_onSelectService);
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<SelectCleanerCount>(_onSelectCleanerCount);
    on<LoadAvailableCleaners>(_onLoadAvailableCleaners);
    on<LoadAvailableCleanersCount>(_onLoadAvailableCleanersCount);
    on<SelectCleaners>(_onSelectCleaners);
    on<SelectLocation>(_onSelectLocation);
    on<SelectPhoneNumber>(_onSelectPhoneNumber);
    on<ConfirmBooking>(_onConfirmBooking);
    on<ResetBooking>(_onResetBooking);
    on<LoadUserPhone>(_onLoadUserPhone);
    on<SetUseWallet>(_onSetUseWallet);
  }

  void _onSelectService(SelectService event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        service: event.service,
        serviceId: event.service.id,
        serviceTitle: event.service.nameAr,
      ),
    );
  }

  void _onSelectDate(SelectDate event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        selectedDate: event.date,
        status: BookingFlowStatus.dateSelected,
      ),
    );
  }

  void _onSelectTime(SelectTime event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        selectedTime: event.time,
        status: BookingFlowStatus.dateSelected,
      ),
    );
  }

  void _onSelectCleanerCount(
    SelectCleanerCount event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        cleanerCount: event.count,
        selectedCleanerIds: [],
        availableCleaners: [],
        status: BookingFlowStatus.countSelected,
      ),
    );
  }

  Future<void> _onLoadAvailableCleaners(
    LoadAvailableCleaners event,
    Emitter<BookingState> emit,
  ) async {
    // Use default values if some are missing
    final date = state.selectedDate ?? DateTime.now();
    final serviceId = state.serviceId ?? 'default_service';
    final count = state.cleanerCount ?? 1;

    final result = await _repository.getAvailableCleaners(
      date: date,
      serviceId: serviceId,
      count: count,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingFlowStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (cleaners) => emit(
        state.copyWith(
          availableCleaners: cleaners,
          status: BookingFlowStatus.countSelected,
        ),
      ),
    );
  }

  Future<void> _onLoadAvailableCleanersCount(
    LoadAvailableCleanersCount event,
    Emitter<BookingState> emit,
  ) async {
    final date = state.selectedDate ?? DateTime.now();
    final serviceId = state.serviceId;

    if (serviceId == null) return;

    emit(state.copyWith(isLoadingCleanerCount: true));

    final result = await _repository.getAvailableCleanersCount(
      date: date,
      serviceId: serviceId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingFlowStatus.error,
          errorMessage: failure.message,
          isLoadingCleanerCount: false,
        ),
      ),
      (count) => emit(
        state.copyWith(
          maxAvailableCleaners: count,
          isLoadingCleanerCount: false,
        ),
      ),
    );
  }

  void _onSelectCleaners(SelectCleaners event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        selectedCleanerIds: event.cleanerIds,
        status: BookingFlowStatus.cleanersSelected,
      ),
    );
  }

  void _onSelectLocation(SelectLocation event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        selectedLocation: event.location,
        status: BookingFlowStatus.locationSelected,
      ),
    );
  }

  void _onSelectPhoneNumber(
    SelectPhoneNumber event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        status: BookingFlowStatus.locationSelected,
      ),
    );
  }

  Future<void> _onConfirmBooking(
    ConfirmBooking event,
    Emitter<BookingState> emit,
  ) async {
    if (!state.canConfirm) return;
    if (state.phoneNumber == null || state.selectedTime == null) return;

    emit(state.copyWith(status: BookingFlowStatus.confirming));

    final totalPrice =
        (state.service?.price ?? 0.0) * (state.cleanerCount ?? 1);

    if (state.useWallet && _walletRepository != null) {
      final walletResult = await _walletRepository.deductWallet(
        totalPrice,
        'دفع مقابل حجز خدمة: ${state.serviceTitle ?? ''}',
      );

      walletResult.fold(
        (failure) => emit(
          state.copyWith(
            status: BookingFlowStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {},
      );

      if (state.status == BookingFlowStatus.error) return;
    }

    final booking = BookingModel(
      id: '',
      userId: '',
      serviceId: state.serviceId!,
      cleanerIds: state.selectedCleanerIds,
      scheduledDate: state.selectedDate!,
      scheduledTime: state.selectedTime!,
      location: state.selectedLocation!,
      status: BookingStatus.pending,
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
    );

    final result = await _repository.createBooking(booking, state.phoneNumber!);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingFlowStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (confirmedBooking) => emit(
        state.copyWith(
          confirmedBooking: confirmedBooking,
          status: BookingFlowStatus.success,
        ),
      ),
    );
  }

  void _onResetBooking(ResetBooking event, Emitter<BookingState> emit) {
    emit(const BookingState.initial());
  }

  Future<void> _onLoadUserPhone(
    LoadUserPhone event,
    Emitter<BookingState> emit,
  ) async {
    final result = await _repository.getUserPhone();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingFlowStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (phone) => emit(state.copyWith(phoneNumber: phone)),
    );
  }

  void _onSetUseWallet(SetUseWallet event, Emitter<BookingState> emit) {
    emit(state.copyWith(useWallet: event.useWallet));
  }
}
