import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/models/order.dart';
import 'package:material_ui/material_ui.dart';

abstract final class RestaurantInfo {
  static const String name = 'Balancika Demo';
  static const String tagline = 'Khmer Kitchen & Coffee';
  static const String address = 'St. 288, Boeng Keng Kang, Phnom Penh';
  static const String openHours = 'Open daily · 10:00 – 22:00';
  static const double rating = 4.9;
  static const int deliveryFee = 4000; // in Riel (thousands display)
  static const int freeDeliveryThreshold = 60000;
}

const List<MenuCategory> menuCategories = <MenuCategory>[
  MenuCategory(id: 'all', label: 'All', icon: Icons.apps_rounded),
  MenuCategory(id: 'rice', label: 'Rice & Bowls', icon: Icons.rice_bowl),
  MenuCategory(id: 'grill', label: 'Grilled', icon: Icons.outdoor_grill),
  MenuCategory(id: 'noodles', label: 'Noodles', icon: Icons.ramen_dining),
  MenuCategory(id: 'soup', label: 'Soups', icon: Icons.soup_kitchen),
  MenuCategory(id: 'veggie', label: 'Veggies', icon: Icons.eco),
  MenuCategory(id: 'drinks', label: 'Drinks', icon: Icons.local_cafe),
  MenuCategory(id: 'sweets', label: 'Sweets', icon: Icons.cake),
];

const List<Dish> menuDishes = <Dish>[
  Dish(
    id: 'fish-amok',
    name: 'Amok Trey',
    description:
        'Steamed fish curry in coconut milk with kroeung (lemongrass, '
        'turmeric and galangal paste), gently cooked in banana leaves and '
        'crowned with silky coconut cream.',
    price: 35000,
    categoryId: 'soup',
    image: 'assets/images/fish-amok.jpg',
    rating: 4.9,
    reviewCount: 328,
    tag: 'National dish',
    prepMinutes: 25,
    calories: 520,
    ingredients: <String>[
      'Fish fillet',
      'Coconut milk',
      'Kroeung paste',
      'Egg',
      'Banana leaf',
      'Noni leaf',
    ],
  ),
  Dish(
    id: 'beef-lok-lak',
    name: 'Beef Lok Lak',
    description:
        'Wok-seared beef cubes marinated in oyster sauce and Kampot pepper, '
        'served with fresh lettuce, tomato, cucumber and a lime–salt–pepper '
        'dipping sauce.',
    price: 40000,
    categoryId: 'grill',
    image: 'assets/images/beef-lok-lak.jpg',
    rating: 4.8,
    reviewCount: 274,
    tag: 'Bestseller',
    prepMinutes: 20,
    calories: 610,
    ingredients: <String>[
      'Beef',
      'Kampot pepper',
      'Oyster sauce',
      'Lettuce',
      'Tomato',
      'Lime',
    ],
  ),
  Dish(
    id: 'bai-sach-chrouk',
    name: 'Bai Sach Chrouk',
    description:
        'Thinly sliced pork marinated in garlic and coconut milk, grilled '
        'over charcoal and served over broken rice with pickled vegetables '
        'and a bowl of clear broth.',
    price: 25000,
    categoryId: 'rice',
    image: 'assets/images/bai-sach-chrouk.jpg',
    rating: 4.9,
    reviewCount: 412,
    tag: 'Breakfast classic',
    prepMinutes: 15,
    calories: 560,
    ingredients: <String>[
      'Pork belly',
      'Garlic',
      'Coconut milk',
      'Broken rice',
      'Pickled cucumber',
      'Broth',
    ],
  ),
  Dish(
    id: 'kuy-teav',
    name: 'Kuy Teav',
    description:
        'Clear rice-noodle soup with slow-simmered pork bone broth, sliced '
        'pork, shrimp and beef balls, topped with fried garlic, bean sprouts '
        'and fresh herbs.',
    price: 20000,
    categoryId: 'noodles',
    image: 'assets/images/kuy-teav.jpg',
    rating: 4.7,
    reviewCount: 351,
    tag: 'Fan favorite',
    prepMinutes: 15,
    calories: 450,
    ingredients: <String>[
      'Rice noodles',
      'Pork broth',
      'Shrimp',
      'Beef balls',
      'Fried garlic',
      'Bean sprouts',
    ],
  ),
  Dish(
    id: 'num-banh-chok',
    name: 'Num Banh Chok',
    description:
        'Fresh rice noodles topped with a fragrant fish curry gravy, crisp '
        'banana blossom, cucumber, long beans and a bouquet of edible '
        'flowers and herbs.',
    price: 22000,
    categoryId: 'noodles',
    image: 'assets/images/num-banh-chok.jpg',
    rating: 4.8,
    reviewCount: 196,
    tag: "Grandma's recipe",
    prepMinutes: 20,
    calories: 430,
    ingredients: <String>[
      'Rice noodles',
      'Fish',
      'Kroeung',
      'Coconut milk',
      'Banana blossom',
      'Fresh herbs',
    ],
  ),
  Dish(
    id: 'cha-kroeung-sach-moan',
    name: 'Sach Moan Cha Kroeung',
    description:
        'Sliced chicken stir-fried with lemongrass–kroeung paste, bell '
        'peppers and fresh basil — bold, aromatic and made for sharing.',
    price: 30000,
    categoryId: 'grill',
    image: 'assets/images/sach-moan-cha-kroeung.jpg',
    rating: 4.7,
    reviewCount: 143,
    prepMinutes: 18,
    calories: 490,
    ingredients: <String>[
      'Chicken',
      'Kroeung paste',
      'Bell pepper',
      'Thai basil',
      'Fish sauce',
    ],
  ),
  Dish(
    id: 'somlar-kako',
    name: 'Somlar Kako',
    description:
        'A traditional sweet-and-sour soup with young tamarind leaves, '
        'pumpkin, yardlong beans and glutinous rice dumplings in a savory '
        'fish broth.',
    price: 25000,
    categoryId: 'veggie',
    image: 'assets/images/somlar-kako.jpg',
    rating: 4.6,
    reviewCount: 98,
    tag: 'Traditional',
    prepMinutes: 30,
    calories: 380,
    ingredients: <String>[
      'Tamarind leaves',
      'Pumpkin',
      'Yardlong beans',
      'Glutinous rice',
      'Fish broth',
    ],
  ),
  Dish(
    id: 'coffee-milk',
    name: 'Kafe Dodob',
    description:
        'Slow-dripped Cambodian iced coffee, brewed dark and strong, poured '
        'over condensed milk and ice — sweet, bold and made by the glass.',
    price: 10000,
    categoryId: 'drinks',
    image: 'assets/images/kafe-dobob.jpg',
    rating: 4.9,
    reviewCount: 388,
    tag: 'Refreshing',
    prepMinutes: 5,
    calories: 170,
    ingredients: <String>['Dark roast coffee', 'Condensed milk', 'Ice'],
  ),
  Dish(
    id: 'tek-kompi',
    name: 'Tek Kompi',
    description:
        'Chilled iced tea with a squeeze of lime — light, crisp and the '
        'perfect partner to anything spicy on the menu.',
    price: 8000,
    categoryId: 'drinks',
    image: 'assets/images/tek-kompi.jpg',
    rating: 4.8,
    reviewCount: 267,
    tag: 'New',
    prepMinutes: 4,
    calories: 90,
    ingredients: <String>['Black tea', 'Cane sugar', 'Lime', 'Ice'],
  ),
  Dish(
    id: 'sdao-siem-reap',
    name: 'Pisang Avey',
    description:
        'Crispy fried banana fritters drizzled with palm sugar caramel and '
        'topped with a scoop of vanilla ice cream.',
    price: 12000,
    categoryId: 'sweets',
    image: 'assets/images/pisang-avey.jpg',
    rating: 4.8,
    reviewCount: 205,
    tag: 'Sweet',
    prepMinutes: 12,
    calories: 450,
    ingredients: <String>[
      'Banana',
      'Rice flour',
      'Palm sugar',
      'Sesame seeds',
      'Vanilla ice cream',
    ],
  ),
];

final Map<String, Dish> menuById = <String, Dish>{
  for (final Dish dish in menuDishes) dish.id: dish,
};

MenuCategory categoryById(String id) => menuCategories.firstWhere(
  (MenuCategory category) => category.id == id,
  orElse: () => menuCategories.first,
);

List<Order> seedOrders() {
  final DateTime now = DateTime.now();
  return <Order>[
    Order(
      id: 'BD-1029',
      placedAt: now.subtract(const Duration(days: 1, hours: 3)),
      lines: const <OrderLine>[
        OrderLine(name: 'Kuy Teav', quantity: 1, price: 20000),
        OrderLine(name: 'Pisang Avey', quantity: 1, price: 12000),
      ],
      mode: DeliveryMode.delivery,
      status: OrderStatus.completed,
      subtotal: 32000,
      deliveryFee: 4000,
    ),
    Order(
      id: 'BD-1024',
      placedAt: now.subtract(const Duration(days: 3, hours: 1)),
      lines: const <OrderLine>[
        OrderLine(name: 'Amok Trey', quantity: 1, price: 35000),
        OrderLine(name: 'Tek Kompi', quantity: 2, price: 8000),
      ],
      mode: DeliveryMode.delivery,
      status: OrderStatus.completed,
      subtotal: 51000,
      deliveryFee: 4000,
    ),
    Order(
      id: 'BD-1019',
      placedAt: now.subtract(const Duration(days: 6, hours: 5)),
      lines: const <OrderLine>[
        OrderLine(name: 'Beef Lok Lak', quantity: 1, price: 40000),
        OrderLine(name: 'Num Banh Chok', quantity: 1, price: 22000),
        OrderLine(name: 'Kafe Dodob', quantity: 1, price: 10000),
      ],
      mode: DeliveryMode.pickup,
      status: OrderStatus.completed,
      subtotal: 72000,
      deliveryFee: 0,
    ),
  ];
}
