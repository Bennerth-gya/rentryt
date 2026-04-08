class OrderModel {
  const OrderModel({
    required this.id,
    required this.dateLabel,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.customerName,
    required this.itemCount,
  });

  final String id;
  final String dateLabel;
  final double amount;
  final String status;
  final String paymentMethod;
  final String customerName;
  final int itemCount;

  OrderModel copyWith({
    String? id,
    String? dateLabel,
    double? amount,
    String? status,
    String? paymentMethod,
    String? customerName,
    int? itemCount,
  }) {
    return OrderModel(
      id: id ?? this.id,
      dateLabel: dateLabel ?? this.dateLabel,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      itemCount: itemCount ?? this.itemCount,
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
        return amount.toStringAsFixed(2);
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
