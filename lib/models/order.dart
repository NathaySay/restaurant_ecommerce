import 'package:material_ui/material_ui.dart';

enum DeliveryMode {
  delivery('Delivery', Icons.delivery_dining),
  pickup('Pickup', Icons.storefront);

  const DeliveryMode(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum OrderStatus {
  preparing('Preparing', Color(0xFF8A5200), Color(0xFFFFEBC7)),
  onTheWay('On the way', Color(0xFF1D5E8C), Color(0xFFDDEFFA)),
  completed('Completed', Color(0xFF31683F), Color(0xFFDCEEE0));

  const OrderStatus(this.label, this.foreground, this.background);

  final String label;
  final Color foreground;
  final Color background;
}

@immutable
class OrderLine {
  const OrderLine({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final int price;

  int get total => price * quantity;
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.placedAt,
    required this.lines,
    required this.mode,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
  });

  final String id;
  final DateTime placedAt;
  final List<OrderLine> lines;
  final DeliveryMode mode;
  final OrderStatus status;
  final int subtotal;
  final int deliveryFee;

  int get total => subtotal + deliveryFee;
}
