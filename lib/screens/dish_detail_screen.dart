import 'package:balancika_demo/core/format.dart';
import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:balancika_demo/widgets/icon_circle_button.dart';
import 'package:balancika_demo/widgets/quantity_stepper.dart';
import 'package:material_ui/material_ui.dart';

class ExtraIngredientOption {
  ExtraIngredientOption({
    required this.id,
    required this.name,
    required this.price,
    this.isSelected = false,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final int price;
  bool isSelected;
  final bool isCustom;
}

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({super.key, required this.dish});

  final Dish dish;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int _quantity = 1;

  late final List<ExtraIngredientOption> _extraOptions;

  @override
  void initState() {
    super.initState();
    _extraOptions = <ExtraIngredientOption>[
      ExtraIngredientOption(
        id: 'extra-meat',
        name: 'Extra Meat / Protein',
        price: 8000,
      ),
      ExtraIngredientOption(id: 'fried-egg', name: 'Fried Egg', price: 3000),
      ExtraIngredientOption(
        id: 'extra-rice',
        name: 'Extra Rice / Side',
        price: 2000,
      ),
      ExtraIngredientOption(
        id: 'extra-sauce',
        name: 'Extra Dip & Spices',
        price: 1000,
      ),
      ExtraIngredientOption(id: 'more-sweet', name: 'More Sweet', price: 1000),
      ExtraIngredientOption(id: 'less-sweet', name: 'Less Sweet', price: 1000),
    ];
  }

  int get _extrasTotalPrice => _extraOptions
      .where((ExtraIngredientOption opt) => opt.isSelected)
      .fold(0, (int sum, ExtraIngredientOption opt) => sum + opt.price);

  int get _unitPrice => widget.dish.price + _extrasTotalPrice;

  void _showAddCustomIngredientDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Custom Ingredient',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.coffee,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Ingredient Name',
                  hintText: 'e.g. Extra Lemongrass, Cheese, Garlic',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Extra Price in ៛ (Optional)',
                  hintText: 'e.g. 2000',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String name = nameController.text.trim();
                if (name.isEmpty) return;
                final int parsedPrice =
                    int.tryParse(priceController.text.trim()) ?? 0;

                setState(() {
                  _extraOptions.add(
                    ExtraIngredientOption(
                      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      price: parsedPrice,
                      isSelected: true,
                      isCustom: true,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add Ingredient'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(AppStore store) {
    final Dish dish = widget.dish;
    store.addToCart(dish, quantity: _quantity);

    final List<String> selectedNames = _extraOptions
        .where((ExtraIngredientOption opt) => opt.isSelected)
        .map((ExtraIngredientOption opt) => opt.name)
        .toList();

    final String extrasText = selectedNames.isNotEmpty
        ? ' with extras (${selectedNames.join(', ')})'
        : '';

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$_quantity × ${dish.name}$extrasText added to cart'),
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
                      Wrap(
                        spacing: 14,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
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
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                          'Base Ingredients',
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Flexible(
                            child: Text(
                              'Add Extra Ingredients',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.coffee,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _showAddCustomIngredientDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text(
                              'Custom',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: <Widget>[
                          for (final ExtraIngredientOption option
                              in _extraOptions)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Material(
                                color: option.isSelected
                                    ? AppColors.sand.withValues(alpha: 0.4)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: option.isSelected
                                        ? AppColors.terracotta
                                        : AppColors.stroke,
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    setState(() {
                                      option.isSelected = !option.isSelected;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: option.isSelected,
                                            activeColor: AppColors.terracotta,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onChanged: (bool? val) {
                                              setState(() {
                                                option.isSelected =
                                                    val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            option.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: option.isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: AppColors.coffee,
                                            ),
                                          ),
                                        ),
                                        if (option.isCustom) ...<Widget>[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.terracotta
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Custom',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.terracottaDeep,
                                              ),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(width: 8),
                                        Text(
                                          option.price > 0
                                              ? '+${rupiah(option.price)}'
                                              : 'Free',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: option.isSelected
                                                ? AppColors.terracottaDeep
                                                : AppColors.taupe,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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
                  'Add to cart · ${rupiah(_unitPrice * _quantity)}',
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
