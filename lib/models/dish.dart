import 'package:material_ui/material_ui.dart';

@immutable
class MenuCategory {
  const MenuCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

@immutable
class Dish {
  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
    required this.rating,
    required this.reviewCount,
    this.tag,
    this.prepMinutes = 20,
    this.calories = 0,
    this.ingredients = const <String>[],
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final String categoryId;
  final String image;
  final double rating;
  final int reviewCount;
  final String? tag;
  final int prepMinutes;
  final int calories;
  final List<String> ingredients;
}

@immutable
class CartItem {
  const CartItem({required this.dish, required this.quantity});

  final Dish dish;
  final int quantity;

  int get lineTotal => dish.price * quantity;
}
