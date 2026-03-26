class Products {
  final String name;
  final String imagePath;        // keep for backward compat (first image)
  final List<String> imagePaths; // all uploaded images
  final String description;
  final double price;
  final List<String> colors;
  final List<String> sizes;
  final double? averageRating;
  final int? reviewCount;
  final String category;

  // ── Seller info ────────────────────────────────────────
  final String? sellerName;
  final String? sellerPhone;
  final String? sellerLocation;
  final String? sellerImagePath; // asset path OR file path from image_picker

  Products({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.price,
    required this.colors,
    required this.sizes,
    required this.category,
    List<String>? imagePaths,
    this.averageRating,
    this.reviewCount,
    this.sellerName,
    this.sellerPhone,
    this.sellerLocation,
    this.sellerImagePath,
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