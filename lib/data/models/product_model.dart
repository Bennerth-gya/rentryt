enum ProductStatus {
  active,
  outOfStock,
  draft,
}

class ProductModel {
  ProductModel({
    String? id,
    required this.name,
    required this.imagePath,
    List<String>? imagePaths,
    required this.description,
    required this.price,
    required this.colors,
    required this.sizes,
    this.averageRating,
    this.reviewCount,
    required this.category,
    this.sellerId,
    this.sellerName,
    this.sellerPhone,
    this.sellerLocation,
    this.sellerImagePath,
    this.inventoryCount = 0,
    this.salesCount = 0,
    this.status = ProductStatus.active,
  })  : id = id ?? _buildProductId(name, imagePath),
        imagePaths = imagePaths == null || imagePaths.isEmpty
            ? <String>[imagePath]
            : List<String>.from(imagePaths);

  final String id;
  final String name;
  final String imagePath;
  final List<String> imagePaths;
  final String description;
  final double price;
  final List<String> colors;
  final List<String> sizes;
  final double? averageRating;
  final int? reviewCount;
  final String category;
  final String? sellerId;
  final String? sellerName;
  final String? sellerPhone;
  final String? sellerLocation;
  final String? sellerImagePath;
  final int inventoryCount;
  final int salesCount;
  final ProductStatus status;

  ProductModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    List<String>? imagePaths,
    String? description,
    double? price,
    List<String>? colors,
    List<String>? sizes,
    double? averageRating,
    int? reviewCount,
    String? category,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    String? sellerLocation,
    String? sellerImagePath,
    int? inventoryCount,
    int? salesCount,
    ProductStatus? status,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imagePaths: imagePaths ?? this.imagePaths,
      description: description ?? this.description,
      price: price ?? this.price,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      sellerLocation: sellerLocation ?? this.sellerLocation,
      sellerImagePath: sellerImagePath ?? this.sellerImagePath,
      inventoryCount: inventoryCount ?? this.inventoryCount,
      salesCount: salesCount ?? this.salesCount,
      status: status ?? this.status,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagePaths = (json['imagePaths'] as List<dynamic>?)
            ?.map((entry) => entry as String)
            .toList() ??
        <String>[];

    return ProductModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      imagePath: (json['imagePath'] as String?) ??
          (imagePaths.isNotEmpty ? imagePaths.first : ''),
      imagePaths: imagePaths,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      colors: (json['colors'] as List<dynamic>? ?? const [])
          .map((entry) => entry as String)
          .toList(),
      sizes: (json['sizes'] as List<dynamic>? ?? const [])
          .map((entry) => entry as String)
          .toList(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      category: json['category'] as String? ?? 'General',
      sellerId: json['sellerId'] as String?,
      sellerName: json['sellerName'] as String?,
      sellerPhone: json['sellerPhone'] as String?,
      sellerLocation: json['sellerLocation'] as String?,
      sellerImagePath: json['sellerImagePath'] as String?,
      inventoryCount: json['inventoryCount'] as int? ?? 0,
      salesCount: json['salesCount'] as int? ?? 0,
      status: ProductStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => ProductStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'imagePaths': imagePaths,
      'description': description,
      'price': price,
      'colors': colors,
      'sizes': sizes,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'category': category,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'sellerLocation': sellerLocation,
      'sellerImagePath': sellerImagePath,
      'inventoryCount': inventoryCount,
      'salesCount': salesCount,
      'status': status.name,
    };
  }

  static String _buildProductId(String name, String imagePath) {
    final normalized = '${name.trim().toLowerCase()}-${imagePath.trim().toLowerCase()}'
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return normalized.isEmpty ? 'product-${DateTime.now().millisecondsSinceEpoch}' : normalized;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
