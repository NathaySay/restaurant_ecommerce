import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/screens/dish_detail_screen.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:balancika_demo/widgets/dish_card.dart';
import 'package:balancika_demo/widgets/icon_circle_button.dart';
import 'package:balancika_demo/widgets/section_header.dart';
import 'package:material_ui/material_ui.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _categoryId = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Dish> get _filteredDishes {
    final String query = _query.trim().toLowerCase();
    return menuDishes.where((Dish dish) {
      final bool matchesCategory =
          _categoryId == 'all' || dish.categoryId == _categoryId;
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      return dish.name.toLowerCase().contains(query) ||
          dish.description.toLowerCase().contains(query) ||
          (dish.tag?.toLowerCase().contains(query) ?? false) ||
          dish.ingredients.any(
            (String ingredient) => ingredient.toLowerCase().contains(query),
          );
    }).toList();
  }

  void _openDish(Dish dish) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DishDetailScreen(dish: dish)),
    );
  }

  void _addToCart(AppStore store, Dish dish) {
    store.addToCart(dish);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${dish.name} added to cart'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () => store.selectTab(1),
          ),
        ),
      );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _categoryId = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    final List<Dish> dishes = _filteredDishes;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(child: _buildSectionHeader(dishes.length)),
            if (dishes.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final Dish dish = dishes[index];
                    return DishCard(
                      dish: dish,
                      isFavorite: store.isFavorite(dish.id),
                      onTap: () => _openDish(dish),
                      onAdd: () => _addToCart(store, dish),
                      onToggleFavorite: () => store.toggleFavorite(dish.id),
                    );
                  }, childCount: dishes.length),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[AppColors.terracotta, AppColors.honey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.terracotta.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Balancika Demo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coffee,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Restaurant Menu',
                      style: TextStyle(fontSize: 11, color: AppColors.taupe),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  IconCircleButton(
                    icon: Icons.notifications_none,
                    iconSize: 21,
                    tooltip: 'Notifications',
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You are all caught up — no new notifications.',
                            ),
                          ),
                        );
                    },
                  ),
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.terracotta,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cream, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'GOOD EVENING',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.taupe,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'What are you craving today?',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 25, height: 1.22),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (String value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search dishes, drinks…',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.taupe),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 21,
                color: AppColors.taupe,
              ),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.taupe,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.stroke),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.terracotta,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Color(0xFFE85D2C), Color(0xFFF0893B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -30,
                top: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: -60,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'OPENING WEEK',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '20% off your first order',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.25,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Demo promo · no payment required',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.ramen_dining,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: menuCategories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final MenuCategory category = menuCategories[index];
          final bool selected = category.id == _categoryId;
          return GestureDetector(
            onTap: () => setState(() => _categoryId = category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? AppColors.coffee : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? AppColors.coffee : AppColors.stroke,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    category.icon,
                    size: 16,
                    color: selected ? AppColors.honey : AppColors.taupe,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : AppColors.coffee,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    final String trimmedQuery = _query.trim();
    final bool searching = trimmedQuery.isNotEmpty;
    final MenuCategory category = categoryById(_categoryId);
    final String title = searching
        ? 'Search results'
        : (_categoryId == 'all' ? 'Popular dishes' : category.label);
    final String subtitle = searching
        ? '$count ${count == 1 ? 'dish' : 'dishes'} for “$trimmedQuery”'
        : 'Fresh from our kitchen, made to order';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: SectionHeader(
        title: title,
        subtitle: subtitle,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.taupe,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.sand,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 28,
              color: AppColors.terracottaDeep,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No dishes found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.coffee,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try another keyword or category.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.taupe),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}
