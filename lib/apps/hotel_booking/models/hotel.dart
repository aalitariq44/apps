class Hotel {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<String> amenities;
  final double startingPrice;
  final List<Room> rooms;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.amenities,
    required this.startingPrice,
    required this.rooms,
  });

  // Dummy data for demonstration
  static List<Hotel> getDummyHotels() {
    return [
      Hotel(
        id: '1',
        name: 'Grand Palace Hotel',
        description: 'Luxury 5-star hotel in the heart of the city with world-class amenities and exceptional service.',
        city: 'Dubai',
        address: 'Downtown Dubai, UAE',
        rating: 4.8,
        reviewCount: 2847,
        images: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
          'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
          'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
        ],
        amenities: ['WiFi', 'Swimming Pool', 'Spa', 'Gym', 'Restaurant', 'Room Service'],
        startingPrice: 250.0,
        rooms: Room.getDummyRooms(),
      ),
      Hotel(
        id: '2',
        name: 'Ocean View Resort',
        description: 'Beautiful beachfront resort with stunning ocean views and tropical paradise atmosphere.',
        city: 'Maldives',
        address: 'North Male Atoll, Maldives',
        rating: 4.9,
        reviewCount: 1523,
        images: [
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
          'https://images.unsplash.com/photo-1578874691223-64558db86d57?w=800',
        ],
        amenities: ['Beach Access', 'Water Sports', 'Spa', 'Multiple Restaurants', 'Bar'],
        startingPrice: 450.0,
        rooms: Room.getDummyRooms(),
      ),
      Hotel(
        id: '3',
        name: 'Mountain Lodge',
        description: 'Cozy mountain retreat with breathtaking alpine views and traditional hospitality.',
        city: 'Switzerland',
        address: 'Swiss Alps, Switzerland',
        rating: 4.7,
        reviewCount: 892,
        images: [
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
          'https://images.unsplash.com/photo-1549294413-26f195200c16?w=800',
          'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
        ],
        amenities: ['Mountain Views', 'Hiking Trails', 'Fireplace', 'Restaurant', 'Ski Access'],
        startingPrice: 180.0,
        rooms: Room.getDummyRooms(),
      ),
      Hotel(
        id: '4',
        name: 'City Business Hotel',
        description: 'Modern business hotel with contemporary design and all necessary amenities for business travelers.',
        city: 'London',
        address: 'Central London, UK',
        rating: 4.5,
        reviewCount: 3421,
        images: [
          'https://images.unsplash.com/photo-1563911302283-d2bc129e7570?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
          'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800',
        ],
        amenities: ['Business Center', 'Meeting Rooms', 'WiFi', 'Gym', 'Restaurant'],
        startingPrice: 120.0,
        rooms: Room.getDummyRooms(),
      ),
      Hotel(
        id: '5',
        name: 'Desert Oasis Resort',
        description: 'Unique desert experience with luxury accommodations and traditional Arabian hospitality.',
        city: 'Morocco',
        address: 'Sahara Desert, Morocco',
        rating: 4.6,
        reviewCount: 756,
        images: [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        ],
        amenities: ['Desert Tours', 'Camel Riding', 'Traditional Dining', 'Spa', 'Stargazing'],
        startingPrice: 200.0,
        rooms: Room.getDummyRooms(),
      ),
    ];
  }
}

enum RoomType {
  standard,
  deluxe,
  suite,
  presidential,
}

class Room {
  final String id;
  final String name;
  final String description;
  final RoomType type;
  final double pricePerNight;
  final int maxGuests;
  final double size; // in square meters
  final List<String> amenities;
  final List<String> images;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.size,
    required this.amenities,
    required this.images,
  });

  String get typeText {
    switch (type) {
      case RoomType.standard:
        return 'Standard Room';
      case RoomType.deluxe:
        return 'Deluxe Room';
      case RoomType.suite:
        return 'Suite';
      case RoomType.presidential:
        return 'Presidential Suite';
    }
  }

  String getTypeText(bool isArabic) {
    switch (type) {
      case RoomType.standard:
        return isArabic ? 'غرفة عادية' : 'Standard Room';
      case RoomType.deluxe:
        return isArabic ? 'غرفة مميزة' : 'Deluxe Room';
      case RoomType.suite:
        return isArabic ? 'جناح' : 'Suite';
      case RoomType.presidential:
        return isArabic ? 'الجناح الرئاسي' : 'Presidential Suite';
    }
  }

  static List<Room> getDummyRooms() {
    return [
      Room(
        id: '1',
        name: 'Standard Room',
        description: 'Comfortable room with all basic amenities for a pleasant stay.',
        type: RoomType.standard,
        pricePerNight: 120.0,
        maxGuests: 2,
        size: 25.0,
        amenities: ['Free WiFi', 'Air Conditioning', 'TV', 'Mini Bar'],
        images: [
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
          'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=800',
        ],
      ),
      Room(
        id: '2',
        name: 'Deluxe Room',
        description: 'Spacious room with premium amenities and beautiful city or garden views.',
        type: RoomType.deluxe,
        pricePerNight: 180.0,
        maxGuests: 3,
        size: 35.0,
        amenities: ['Free WiFi', 'Air Conditioning', 'Smart TV', 'Mini Bar', 'Room Service', 'Balcony'],
        images: [
          'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        ],
      ),
      Room(
        id: '3',
        name: 'Executive Suite',
        description: 'Luxurious suite with separate living area and premium amenities.',
        type: RoomType.suite,
        pricePerNight: 350.0,
        maxGuests: 4,
        size: 65.0,
        amenities: ['Free WiFi', 'Air Conditioning', 'Smart TV', 'Mini Bar', 'Room Service', 'Living Area', 'Work Desk'],
        images: [
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800',
        ],
      ),
      Room(
        id: '4',
        name: 'Presidential Suite',
        description: 'The ultimate luxury experience with panoramic views and exclusive services.',
        type: RoomType.presidential,
        pricePerNight: 800.0,
        maxGuests: 6,
        size: 120.0,
        amenities: ['Free WiFi', 'Air Conditioning', 'Smart TV', 'Full Kitchen', 'Butler Service', 'Private Terrace', 'Jacuzzi'],
        images: [
          'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=800',
          'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
        ],
      ),
    ];
  }
}
