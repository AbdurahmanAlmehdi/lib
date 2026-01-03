import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

abstract class BookingRepository {
  ResultFuture<List<Cleaner>> getAvailableCleaners({
    required DateTime date,
    required String serviceId,
    int count = 1,
  });
  ResultFuture<int> getAvailableCleanersCount({
    required DateTime date,
    required String serviceId,
  });
  ResultFuture<Booking> createBooking(Booking booking, String phoneNumber);
  ResultFuture<List<Booking>> getUserBookings();
  ResultFuture<Booking> cancelBooking(String bookingId, String? reason);
  ResultFuture<String> getUserPhone();
}
