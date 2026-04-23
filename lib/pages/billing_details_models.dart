import 'package:comfi/models/products.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════════

enum DeliveryType { home, pickup }

enum MomoProvider { mtn, vodafone, airteltigo }

enum PaymentStatus { idle, pending, success, failed, timeout }

const List<DeliveryOption> defaultBillingDeliveryOptions = [
  DeliveryOption(
    id: 'home_standard',
    title: 'Home Delivery',
    subtitle: 'Delivered to your doorstep',
    fee: 18,
    timeEstimate: '2-4 business days',
    type: DeliveryType.home,
  ),
  DeliveryOption(
    id: 'pickup_station',
    title: 'Pickup Station',
    subtitle: 'Collect from a nearby Comfi hub',
    fee: 8,
    timeEstimate: 'Ready in 1-2 days',
    type: DeliveryType.pickup,
  ),
];

const UserAddress defaultBillingAddress = UserAddress(
  line1: '25 Liberation Road, Accra',
  ghanaPostGps: 'GA-123-4567',
  landmark: 'Near Total Filling Station',
);

const Object _billingSentinel = Object();

class OrderItem {
  final String id;
  final String name;
  final String sellerName;
  final double sellerRating;
  final bool sellerVerified;
  final String? imageUrl;
  final double originalPrice;
  final double? negotiatedPrice;
  final String currency;
  final int quantity;

  const OrderItem({
    required this.id,
    required this.name,
    required this.sellerName,
    required this.sellerRating,
    required this.sellerVerified,
    this.imageUrl,
    required this.originalPrice,
    this.negotiatedPrice,
    this.currency = 'GHS',
    this.quantity = 1,
  });

  double get effectivePrice => negotiatedPrice ?? originalPrice;
  double get savings => originalPrice - effectivePrice;
  bool get hasNegotiatedPrice =>
      negotiatedPrice != null && negotiatedPrice! < originalPrice;

  OrderItem copyWith({
    String? id,
    String? name,
    String? sellerName,
    double? sellerRating,
    bool? sellerVerified,
    Object? imageUrl = _billingSentinel,
    double? originalPrice,
    Object? negotiatedPrice = _billingSentinel,
    String? currency,
    int? quantity,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sellerName: sellerName ?? this.sellerName,
      sellerRating: sellerRating ?? this.sellerRating,
      sellerVerified: sellerVerified ?? this.sellerVerified,
      imageUrl: identical(imageUrl, _billingSentinel)
          ? this.imageUrl
          : imageUrl as String?,
      originalPrice: originalPrice ?? this.originalPrice,
      negotiatedPrice: identical(negotiatedPrice, _billingSentinel)
          ? this.negotiatedPrice
          : negotiatedPrice as double?,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
    );
  }
}

class BillingDetailsRouteData {
  final OrderItem item;
  final List<DeliveryOption> deliveryOptions;
  final UserAddress? savedAddress;

  const BillingDetailsRouteData({
    required this.item,
    required this.deliveryOptions,
    this.savedAddress,
  });

  factory BillingDetailsRouteData.fromRouteArguments(Object? arguments) {
    if (arguments is BillingDetailsRouteData) {
      return arguments;
    }
    if (arguments is Products) {
      return BillingDetailsRouteData.fromProduct(arguments);
    }
    if (arguments is Map<Products, int>) {
      return BillingDetailsRouteData.fromCart(arguments);
    }
    return BillingDetailsRouteData.fallback();
  }

  factory BillingDetailsRouteData.fromProduct(
    Products product, {
    int quantity = 1,
    String? selectedColor,
    String? selectedSize,
  }) { 
    final normalizedQuantity = quantity < 1 ? 1 : quantity;
    final variantParts = <String>[
      if (selectedColor != null && selectedColor.trim().isNotEmpty)
        selectedColor.trim(),
      if (selectedSize != null && selectedSize.trim().isNotEmpty)
        'Size ${selectedSize.trim()}',
    ];

    final displayName = variantParts.isEmpty
        ? product.name
        : '${product.name} (${variantParts.join(', ')})';

    return BillingDetailsRouteData(
      item: OrderItem(
        id: product.id,
        name: displayName,
        sellerName: _resolveSellerName(product.sellerName),
        sellerRating: product.averageRating ?? 4.8,
        sellerVerified: true,
        imageUrl: product.imagePath.isEmpty ? null : product.imagePath,
        originalPrice: product.price * normalizedQuantity,
        currency: 'GHS',
        quantity: normalizedQuantity,
      ),
      deliveryOptions: defaultBillingDeliveryOptions,
      savedAddress: defaultBillingAddress,
    );
  }

  factory BillingDetailsRouteData.fromCart(Map<Products, int> cartEntries) {
    if (cartEntries.isEmpty) {
      return BillingDetailsRouteData.fallback();
    }

    final entries = cartEntries.entries.toList();
    if (entries.length == 1) {
      return BillingDetailsRouteData.fromProduct(
        entries.first.key,
        quantity: entries.first.value,
      );
    }

    final totalQuantity = entries.fold<int>(
      0,
      (sum, entry) => sum + entry.value,
    );
    final subtotal = entries.fold<double>(
      0,
      (sum, entry) => sum + (entry.key.price * entry.value),
    );
    final sellerNames = entries
        .map((entry) => entry.key.sellerName?.trim())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toSet();
    final ratings = entries
        .map((entry) => entry.key.averageRating)
        .whereType<double>()
        .toList();
    final averageRating = ratings.isEmpty
        ? 0.0
        : ratings.reduce((left, right) => left + right) / ratings.length;

    return BillingDetailsRouteData(
      item: OrderItem(
        id: 'cart-checkout',
        name:
            '$totalQuantity item${totalQuantity == 1 ? '' : 's'} from your cart',
        sellerName: sellerNames.length == 1
            ? sellerNames.first
            : 'Multiple sellers',
        sellerRating: double.parse(averageRating.toStringAsFixed(1)),
        sellerVerified: sellerNames.length == 1,
        imageUrl: entries.first.key.imagePath.isEmpty
            ? null
            : entries.first.key.imagePath,
        originalPrice: subtotal,
        currency: 'GHS',
        quantity: totalQuantity,
      ),
      deliveryOptions: defaultBillingDeliveryOptions,
      savedAddress: defaultBillingAddress,
    );
  }

  factory BillingDetailsRouteData.fallback() {
    return const BillingDetailsRouteData(
      item: OrderItem(
        id: 'checkout-preview',
        name: 'Checkout item',
        sellerName: 'Comfi Store',
        sellerRating: 4.8,
        sellerVerified: true,
        originalPrice: 0,
        currency: 'GHS',
      ),
      deliveryOptions: defaultBillingDeliveryOptions,
      savedAddress: defaultBillingAddress,
    );
  }

  static String _resolveSellerName(String? sellerName) {
    final normalized = sellerName?.trim() ?? '';
    return normalized.isEmpty ? 'Comfi Store' : normalized;
  }
}

class DeliveryOption {
  final String id;
  final String title;
  final String subtitle;
  final double fee;
  final String timeEstimate;
  final DeliveryType type;

  const DeliveryOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.fee,
    required this.timeEstimate,
    required this.type,
  });
}

class UserAddress {
  final String line1;
  final String? line2;
  final String? ghanaPostGps;
  final String? landmark;

  const UserAddress({
    required this.line1,
    this.line2,
    this.ghanaPostGps,
    this.landmark,
  });
}

class OrderTotal {
  final double itemPrice;
  final double discount;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double total;

  const OrderTotal({
    required this.itemPrice,
    required this.discount,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tax,
    required this.total,
  });

  /// Server should return this. Client-side calc is for display preview only.
  factory OrderTotal.compute({
    required double effectivePrice,
    required double originalPrice,
    required double deliveryFee,
    double serviceFeeRate = 0.025,
    double vatRate = 0.15,
  }) {
    final discount = originalPrice - effectivePrice;
    final serviceFee = double.parse(
      (effectivePrice * serviceFeeRate).toStringAsFixed(2),
    );
    final tax = double.parse((serviceFee * vatRate).toStringAsFixed(2));
    final total = double.parse(
      (effectivePrice + deliveryFee + serviceFee + tax).toStringAsFixed(2),
    );
    return OrderTotal(
      itemPrice: effectivePrice,
      discount: discount,
      deliveryFee: deliveryFee,
      serviceFee: serviceFee,
      tax: tax,
      total: total,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  MAIN BILLING DETAILS SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
