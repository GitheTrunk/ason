import '../models/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();

  Future<Booking> createBooking(Booking booking);
}
