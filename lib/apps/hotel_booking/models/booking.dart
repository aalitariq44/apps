import 'hotel.dart';

class BookingData {
  final Hotel hotel;
  final Room room;
  final int numberOfRooms;
  final SearchCriteria? searchCriteria;
  final double totalPrice;

  BookingData({
    required this.hotel,
    required this.room,
    required this.numberOfRooms,
    this.searchCriteria,
    required this.totalPrice,
  });
}

class Booking {
  final String id;
  final String hotelId;
  final String hotelName;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final List<BookingRoom> rooms;
  final double totalAmount;
  final DateTime bookingDate;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.rooms,
    required this.totalAmount,
    required this.bookingDate,
    this.status = BookingStatus.confirmed,
  });

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }
}

class BookingRoom {
  final String roomId;
  final String roomName;
  final String roomType;
  final int quantity;
  final double pricePerNight;

  BookingRoom({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.quantity,
    required this.pricePerNight,
  });

  double get totalPrice {
    return pricePerNight * quantity;
  }
}

enum BookingStatus {
  confirmed,
  pending,
  cancelled,
  completed,
}

class SearchCriteria {
  final String destination;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final int numberOfRooms;

  SearchCriteria({
    required this.destination,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    this.numberOfRooms = 1,
  });

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });

  static User getDummyUser() {
    return User(
      id: 'user_1',
      name: 'Ahmed Hassan',
      email: 'ahmed.hassan@example.com',
      phone: '+971501234567',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
    );
  }
}
