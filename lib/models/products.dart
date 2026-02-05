class Products {
  final String name;
  final String imagePath;
  final String? description;
  final double? price;
  final List<String> colors; // e.g. ["#FF5733", "#000000", "#FFFFFF"]
  final List<String> sizes; // e.g. ["S", "M", "L", "XL"]
  final double? averageRating; // e.g. 4.7
  final int? reviewCount; // e.g. 128
  // Optional: List of reviews if you want to hardcode or pass them
  final List<Review>? reviews;

  Products({
    required this.name,
    required this.imagePath,
    this.description,
    this.price,
    this.colors = const [],
    this.sizes = const [],
    this.averageRating,
    this.reviewCount,
    this.reviews,
  });
}

// Simple review model
class Review {
  final String userName;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
