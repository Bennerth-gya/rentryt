class Products {
  final String name;
  final String imagePath;        // keep for backward compat (first image)
  final List<String> imagePaths; // ← new: all uploaded images
  final String description;
  final double price;
  final List<String> colors;
  final List<String> sizes;
  final double? averageRating;
  final int? reviewCount;
  final String category;

  Products({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.price,
    required this.colors,
    required this.sizes,
    required this.category,
    List<String>? imagePaths,   // optional — falls back to [imagePath]
    this.averageRating,
    this.reviewCount,
  }) : imagePaths = imagePaths ?? [imagePath];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Products &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}