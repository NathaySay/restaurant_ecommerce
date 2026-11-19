import 'package:balancika_demo/core/format.dart';
import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/models/order.dart';
import 'package:balancika_demo/screens/dish_detail_screen.dart';
import 'package:balancika_demo/screens/edit_profile.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:balancika_demo/widgets/icon_circle_button.dart';
import 'package:balancika_demo/widgets/section_header.dart';
import 'package:material_ui/material_ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    final List<Dish> favorites = store.favorites
        .map((String id) => menuById[id])
        .whereType<Dish>()
        .toList();
    final int orderCount = store.orders.length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                IconCircleButton(
                  icon: Icons.edit,
                  iconSize: 17,
                  tooltip: 'Edit profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[AppColors.terracotta, AppColors.honey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.terracotta.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'BK',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'balancikaDemo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'sample@mail.com',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.taupe,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sand,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'GOLD MEMBER',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.terracottaDeep,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _MembershipCard(),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Favorites',
              subtitle: 'Saved for your next craving',
              trailing: Text(
                '${favorites.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.taupe,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (favorites.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: AppColors.terracotta,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tap the heart on any dish to keep it here for later.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.taupe,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 152,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final Dish dish = favorites[index];
                    return SizedBox(
                      width: 148,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x0F2D1B12),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        DishDetailScreen(dish: dish),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    dish.image,
                                    width: double.infinity,
                                    height: 92,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      height: 92,
                                      color: AppColors.sand,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.restaurant,
                                        size: 24,
                                        color: AppColors.taupe,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      8,
                                      10,
                                      10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          dish.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.coffee,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          rupiah(dish.price),
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.terracottaDeep,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Order history',
              subtitle:
                  '$orderCount ${orderCount == 1 ? 'order' : 'orders'} with Balancika',
            ),
            const SizedBox(height: 12),
            if (store.orders.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: const Text(
                  'No orders yet — your first one is waiting to happen.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.taupe),
                ),
              )
            else
              for (final Order order in store.orders)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OrderCard(order: order),
                ),
            const SizedBox(height: 10),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: 12),
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.stroke),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  _SettingsTile(
                    icon: Icons.location_on,
                    title: 'Delivery address',
                    subtitle: RestaurantInfo.address,
                    onTap: () =>
                        _showSnack(context, 'Address editing is coming soon.'),
                  ),
                  const Divider(indent: 60, endIndent: 16),
                  _SettingsTile(
                    icon: Icons.credit_card,
                    title: 'Payment method',
                    subtitle: 'Cash on delivery',
                    onTap: () => _showSnack(
                      context,
                      'More payment methods are coming soon.',
                    ),
                  ),
                  const Divider(indent: 60, endIndent: 16),
                  _SettingsTile(
                    icon: Icons.support_agent,
                    title: 'Help & support',
                    subtitle: 'We reply within a day',
                    onTap: () =>
                        _showSnack(context, 'Support chat is coming soon.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Balancika Demo · v1.0.0 · Static demo',
                style: TextStyle(fontSize: 10.5, color: AppColors.taupe),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[AppColors.coffee, Color(0xFF4A2E1F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -24,
              top: -36,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.honey.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'BALANCIKA REWARDS',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.honey,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1,240 points',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '≈ ៛124,000 off your next order',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: AppColors.honey,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: order.status.foreground,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                formatDateTime(order.placedAt),
                style: const TextStyle(fontSize: 10, color: AppColors.taupe),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.lines
                .map((OrderLine line) => '${line.quantity} × ${line.name}')
                .join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.5,
              color: AppColors.taupe,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(order.mode.icon, size: 14, color: AppColors.taupe),
              const SizedBox(width: 4),
              Text(
                order.mode.label,
                style: const TextStyle(fontSize: 10.5, color: AppColors.taupe),
              ),
              const Spacer(),
              Text(
                rupiah(order.total),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.terracottaDeep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.sand,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: AppColors.terracottaDeep),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.taupe,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.taupe),
          ],
        ),
      ),
    );
  }
}
