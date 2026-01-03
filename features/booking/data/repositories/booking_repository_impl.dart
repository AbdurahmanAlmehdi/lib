import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:buzzy_bee/features/booking/data/models/booking_model.dart';
import 'package:buzzy_bee/features/booking/domain/repositories/booking_repository.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<Cleaner>> getAvailableCleaners({
    required DateTime date,
    required String serviceId,
    int count = 1,
  }) async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.getAvailableCleaners(
          date: date,
          serviceId: serviceId,
          count: count,
        );
      },
      operationName: 'Get Available Cleaners',
    );
  }

  @override
  ResultFuture<int> getAvailableCleanersCount({
    required DateTime date,
    required String serviceId,
  }) async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.getAvailableCleanersCount(
          date: date,
          serviceId: serviceId,
        );
      },
      operationName: 'Get Available Cleaners Count',
    );
  }

  @override
  ResultFuture<Booking> createBooking(Booking booking, String phoneNumber) async {
    return await RepositoryHelper.execute(
      operation: () async {
        final bookingModel = BookingModel.fromEntity(booking);
        return await _remoteDataSource.createBooking(bookingModel, phoneNumber);
      },
      operationName: 'Create Booking',
    );
  }

  @override
  ResultFuture<List<Booking>> getUserBookings() async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.getUserBookings();
      },
      operationName: 'Get User Bookings',
    );
  }

  @override
  ResultFuture<Booking> cancelBooking(String bookingId, String? reason) async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.cancelBooking(bookingId, reason);
      },
      operationName: 'Cancel Booking',
    );
  }

  @override
  ResultFuture<String> getUserPhone() async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.getUserPhone();
      },
      operationName: 'Get User Phone',
    );
  }
}
