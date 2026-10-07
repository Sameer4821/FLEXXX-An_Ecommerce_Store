import 'cart_item_model.dart';

enum OrderStatus {
  placed,
  confirmed,
  packed,
  shipped,
  outForDelivery,
  delivered,
  cancelled
}

class OrderStep {
  final OrderStatus status;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isCompleted;

  const OrderStep({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isCompleted = false,
  });
}

class OrderModel {
  final String orderId;
  final List<CartItemModel> items;
  final OrderStatus currentStatus;
  final List<OrderStep> timeline;
  final double totalAmount;
  final String paymentMethod;
  final String shippingAddress;
  final String trackingId;
  final String courierPartner;
  final DateTime estimatedDelivery;
  final DateTime createdAt;

  const OrderModel({
    required this.orderId,
    required this.items,
    required this.currentStatus,
    required this.timeline,
    required this.totalAmount,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.trackingId,
    required this.courierPartner,
    required this.estimatedDelivery,
    required this.createdAt,
  });
}
