import 'package:balancika_demo/core/format.dart';
import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:balancika_demo/widgets/icon_circle_button.dart';
import 'package:balancika_demo/widgets/quantity_stepper.dart';
import 'package:material_ui/material_ui.dart';

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({super.key, required this.dish});

  final Dish dish;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int _quantity = 1;

  void _addToCart(AppStore store) {
    final Dish dish = widget.dish;
    store.addToCart(dish, quantity: _quantity);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$_quantity × ${dish.name} added to cart'),
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () => store.selectTab(1),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    final Dish dish = widget.dish;
    final MenuCategory category = categoryById(dish.categoryId);
    final bool isFavorite = store.isFavorite(dish.id);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                stretch: true,
                expandedHeight: 340,
                backgroundColor: AppColors.cream,
                surfaceTintColor: Colors.transparent,
                leadingWidth: 68,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: IconCircleButton(
                      icon: Icons.arrow_back,
                      tooltip: 'Back',
                      backgroundColor: Colors.white.withValues(alpha: 0.92),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: IconCircleButton(
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: isFavorite
                            ? AppColors.terracotta
                            : AppColors.coffee,
                        tooltip: isFavorite
                            ? 'Remove from favorites'
                            : 'Save to favorites',
                        backgroundColor: Colors.white.withValues(alpha: 0.92),
                        onPressed: () => store.toggleFavorite(dish.id),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        dish.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.sand,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.restaurant,
                            size: 48,
                            color: AppColors.taupe,
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: <double>[0.0, 0.62, 1.0],
                            colors: <Color>[
                              Colors.transparent,
                              Color(0x14000000),
                              AppColors.cream,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (dish.tag != null) ...<Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.sand,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                dish.tag!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.terracottaDeep,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          const Spacer(),
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            dish.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coffee,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '· ${dish.reviewCount} reviews',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.taupe,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        dish.name,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontSize: 26, height: 1.2),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.schedule,
                            size: 15,
                            color: AppColors.taupe,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dish.prepMinutes} min',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.taupe,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.local_fire_department,
                            size: 15,
                            color: AppColors.taupe,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dish.calories} kcal',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.taupe,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.restaurant,
                            size: 15,
                            color: AppColors.taupe,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category.label,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.taupe,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dish.description,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.sand.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.format_quote,
                              size: 20,
                              color: AppColors.terracottaDeep,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Cooked to order in our open kitchen. Best '
                                'enjoyed while it is still warm.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.55,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (dish.ingredients.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 20),
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.coffee,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            for (final String ingredient in dish.ingredients)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.stroke),
                                ),
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.inkSoft,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, store, dish),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppStore store, Dish dish) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            QuantityStepper(
              quantity: _quantity,
              onIncrement: () => setState(() => _quantity++),
              onDecrement: () {
                if (_quantity > 1) {
                  setState(() => _quantity--);
                }
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => _addToCart(store),
                child: Text(
                  'Add to cart · ${rupiah(dish.price * _quantity)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
