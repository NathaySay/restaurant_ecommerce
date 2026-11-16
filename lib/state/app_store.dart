import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/models/order.dart';
import 'package:flutter/foundation.dart';

class AppStore extends ChangeNotifier {
  AppStore({List<Order> seedOrders = const <Order>[]})
    : _orders = List<Order>.of(seedOrders),
      _favorites = <String>{'sate-ayam', 'kopi-susu'};

  final Map<String, int> _quantities = <String, int>{};
  final Set<String> _favorites;
  final List<Order> _orders;
  int _selectedTab = 0;
  DeliveryMode _mode = DeliveryMode.delivery;
  int _nextOrderNumber = 1031;

  List<Order> get orders => List<Order>.unmodifiable(_orders);
  Set<String> get favorites => Set<String>.unmodifiable(_favorites);
  int get selectedTab => _selectedTab;
  DeliveryMode get mode => _mode;

  List<CartItem> get cartItems => <CartItem>[
    for (final MapEntry<String, int> entry in _quantities.entries)
      CartItem(dish: menuById[entry.key]!, quantity: entry.value),
  ];

  bool get cartIsEmpty => _quantities.isEmpty;
  int get cartCount =>
      _quantities.values.fold(0, (int sum, int quantity) => sum + quantity);
  int get subtotal =>
      cartItems.fold(0, (int sum, CartItem item) => sum + item.lineTotal);

  int get deliveryFee {
    if (_mode == DeliveryMode.pickup) return 0;
    if (subtotal == 0) return 0;
    return subtotal >= RestaurantInfo.freeDeliveryThreshold
        ? 0
        : RestaurantInfo.deliveryFee;
  }

  int get total => subtotal + deliveryFee;

  int quantityOf(String dishId) => _quantities[dishId] ?? 0;

  bool isFavorite(String dishId) => _favorites.contains(dishId);

  void selectTab(int index) {
    if (index == _selectedTab) return;
    _selectedTab = index;
    notifyListeners();
  }

  void addToCart(Dish dish, {int quantity = 1}) {
    if (quantity <= 0) return;
    _quantities[dish.id] = (_quantities[dish.id] ?? 0) + quantity;
    notifyListeners();
  }

  void increment(String dishId) {
    final int? quantity = _quantities[dishId];
    if (quantity == null) return;
    _quantities[dishId] = quantity + 1;
    notifyListeners();
  }

  void decrement(String dishId) {
    final int? quantity = _quantities[dishId];
    if (quantity == null) return;
    if (quantity <= 1) {
      _quantities.remove(dishId);
    } else {
      _quantities[dishId] = quantity - 1;
    }
    notifyListeners();
  }

  void removeFromCart(String dishId) {
    if (_quantities.remove(dishId) != null) {
      notifyListeners();
    }
  }

  void clearCart() {
    if (_quantities.isEmpty) return;
    _quantities.clear();
    notifyListeners();
  }

  void toggleFavorite(String dishId) {
    if (!_favorites.add(dishId)) {
      _favorites.remove(dishId);
    }
    notifyListeners();
  }

  void setMode(DeliveryMode mode) {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
  }

  Order placeOrder() {
    final List<CartItem> items = cartItems;
    final int orderSubtotal = subtotal;
    final int orderDeliveryFee = deliveryFee;
    final DeliveryMode orderMode = _mode;

    final Order order = Order(
      id: 'BD-${_nextOrderNumber++}',
      placedAt: DateTime.now(),
      lines: <OrderLine>[
        for (final CartItem item in items)
          OrderLine(
            name: item.dish.name,
            quantity: item.quantity,
            price: item.dish.price,
          ),
      ],
      mode: orderMode,
      status: OrderStatus.preparing,
      subtotal: orderSubtotal,
      deliveryFee: orderDeliveryFee,
    );

    _orders.insert(0, order);
    _quantities.clear();
    notifyListeners();
    return order;
  }
}
