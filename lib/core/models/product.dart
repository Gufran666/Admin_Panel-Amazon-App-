class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final int reorderThreshold;
  final double rating;
  final int reviewsCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    required this.reorderThreshold,
    required this.rating,
    required this.reviewsCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as double,
      category: json['category'] as String,
      stock: json['stock'] as int,
      reorderThreshold: json['reorderThreshold'] as int,
      rating: json['rating'] as double,
      reviewsCount: json['reviewsCount'] as int,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'stock': stock,
      'reorderThreshold': reorderThreshold,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }


  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      reorderThreshold: reorderThreshold ?? this.reorderThreshold,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}
