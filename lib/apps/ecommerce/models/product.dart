class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewsCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  // Dummy data for showcase
  static List<Product> getDummyProducts() {
    return [
      Product(
        id: '1',
        name: 'Headphones',
        description: 'High-quality wireless headphones with noise cancellation and long battery life.',
        price: 199.99,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
        category: 'Electronics',
        rating: 4.5,
        reviewsCount: 128,
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        description: 'Advanced smartwatch with health monitoring and fitness tracking features.',
        price: 299.99,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
        category: 'Electronics',
        rating: 4.3,
        reviewsCount: 89,
      ),
      Product(
        id: '3',
        name: 'Running Shoes',
        description: 'Comfortable running shoes designed for performance and durability.',
        price: 129.99,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        category: 'Sports',
        rating: 4.7,
        reviewsCount: 256,
      ),
      Product(
        id: '4',
        name: 'Coffee Maker',
        description: 'Automatic coffee maker with programmable settings and thermal carafe.',
        price: 89.99,
        imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500',
        category: 'Home',
        rating: 4.2,
        reviewsCount: 67,
      ),
      Product(
        id: '5',
        name: 'Laptop Backpack',
        description: 'Durable laptop backpack with multiple compartments and water resistance.',
        price: 79.99,
        imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
        category: 'Bags',
        rating: 4.4,
        reviewsCount: 143,
      ),
      Product(
        id: '6',
        name: 'Bluetooth Speaker',
        description: 'Portable Bluetooth speaker with excellent sound quality and long battery life.',
        price: 59.99,
        imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500',
        category: 'Electronics',
        rating: 4.6,
        reviewsCount: 201,
      ),
    ];
  }
}
