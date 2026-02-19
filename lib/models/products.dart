class Products {
  final String name;
  final String imagePath;
  final String description;
  final double price;
  final List<String> colors;
  final List<String> sizes;
  final double? averageRating;
  final int? reviewCount;
  final String category; // ← moved here + made final

  Products({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.price,
    required this.colors,
    required this.sizes,
    required this.category, // ← now properly inside as required named param
    this.averageRating,
    this.reviewCount,
  });

  // Important for Map<Products, int> – equality based on name only
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Products &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
