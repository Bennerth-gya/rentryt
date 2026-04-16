class OrderModel {
  const OrderModel({
    required this.id,
    required this.dateLabel,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.customerName,
    required this.itemCount,
    this.currency = 'GHS',
    this.productId,
    this.productName,
    this.buyerId,
    this.sellerId,
    this.chatId,
    this.offerId,
    this.lockedUnitPrice,
    this.isNegotiated = false,
  });

  final String id;
  final String dateLabel;
  final double amount;
  final String status;
  final String paymentMethod;
  final String customerName;
  final int itemCount;
  final String currency;
  final String? productId;
  final String? productName;
  final String? buyerId;
  final String? sellerId;
  final String? chatId;
  final String? offerId;
  final double? lockedUnitPrice;
  final bool isNegotiated;

  OrderModel copyWith({
    String? id,
    String? dateLabel,
    double? amount,
    String? status,
    String? paymentMethod,
    String? customerName,
    int? itemCount,
    String? currency,
    Object? productId = _sentinel,
    Object? productName = _sentinel,
    Object? buyerId = _sentinel,
    Object? sellerId = _sentinel,
    Object? chatId = _sentinel,
    Object? offerId = _sentinel,
    Object? lockedUnitPrice = _sentinel,
    bool? isNegotiated,
  }) {
    return OrderModel(
      id: id ?? this.id,
      dateLabel: dateLabel ?? this.dateLabel,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      itemCount: itemCount ?? this.itemCount,
      currency: currency ?? this.currency,
      productId: identical(productId, _sentinel)
          ? this.productId
          : productId as String?,
      productName: identical(productName, _sentinel)
          ? this.productName
          : productName as String?,
      buyerId: identical(buyerId, _sentinel)
          ? this.buyerId
          : buyerId as String?,
      sellerId: identical(sellerId, _sentinel)
          ? this.sellerId
          : sellerId as String?,
      chatId: identical(chatId, _sentinel) ? this.chatId : chatId as String?,
      offerId: identical(offerId, _sentinel)
          ? this.offerId
          : offerId as String?,
      lockedUnitPrice: identical(lockedUnitPrice, _sentinel)
          ? this.lockedUnitPrice
          : lockedUnitPrice as double?,
      isNegotiated: isNegotiated ?? this.isNegotiated,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      dateLabel: json['dateLabel'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String,
      customerName: json['customerName'] as String,
      itemCount: json['itemCount'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'GHS',
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      buyerId: json['buyerId'] as String?,
      sellerId: json['sellerId'] as String?,
      chatId: json['chatId'] as String?,
      offerId: json['offerId'] as String?,
      lockedUnitPrice: (json['lockedUnitPrice'] as num?)?.toDouble(),
      isNegotiated: json['isNegotiated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateLabel': dateLabel,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'customerName': customerName,
      'itemCount': itemCount,
      'currency': currency,
      'productId': productId,
      'productName': productName,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'chatId': chatId,
      'offerId': offerId,
      'lockedUnitPrice': lockedUnitPrice,
      'isNegotiated': isNegotiated,
    };
  }

  Object? operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'date':
      case 'dateLabel':
        return dateLabel;
      case 'amount':
        return '$currency ${amount.toStringAsFixed(2)}';
      case 'status':
        return status;
      case 'payment':
      case 'paymentMethod':
        return paymentMethod;
      case 'customer':
      case 'customerName':
        return customerName;
      case 'items':
      case 'itemCount':
        return itemCount;
      default:
        return null;
    }
  }
}

const Object _sentinel = Object();
