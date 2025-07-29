import 'package:intl/intl.dart';

class Order {
  final String id;
  final DateTime date;
  final double total;
  final String status;
  final List<OrderItem> items;
  final String userId;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
    required this.userId,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);

  String get formattedTime => DateFormat('HH:mm').format(date);

  Order copyWith({
    String? id,
    DateTime? date,
    double? total,
    String? status,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      date: date ?? this.date,
      total: total ?? this.total,
      status: status ?? this.status,
      items: items ?? this.items,
      userId: userId ?? this.userId,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
  });

  OrderItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }
}
