import 'package:balancika_demo/screens/cart_screen.dart';
import 'package:balancika_demo/screens/menu_screen.dart';
import 'package:balancika_demo/screens/profile_screen.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: IndexedStack(
            index: store.selectedTab,
            children: const <Widget>[
              MenuScreen(),
              CartScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ColoredBox(
        color: AppColors.cream,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.stroke)),
              ),
              child: NavigationBar(
                selectedIndex: store.selectedTab,
                onDestinationSelected: (int index) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  store.selectTab(index);
                },
                destinations: <NavigationDestination>[
                  const NavigationDestination(
                    icon: Icon(Icons.restaurant_menu),
                    selectedIcon: Icon(Icons.restaurant_menu),
                    label: 'Menu',
                  ),
                  NavigationDestination(
                    icon: _CartIcon(count: store.cartCount),
                    selectedIcon: _CartIcon(
                      count: store.cartCount,
                      selected: true,
                    ),
                    label: 'Cart',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, this.selected = false});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: Icon(selected ? Icons.shopping_bag : Icons.shopping_bag_outlined),
    );
  }
}
