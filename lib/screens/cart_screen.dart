import 'package:balancika_demo/core/format.dart';
import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/models/order.dart';
import 'package:balancika_demo/screens/order_success_screen.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:balancika_demo/widgets/quantity_stepper.dart';
import 'package:material_ui/material_ui.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context, AppStore store) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Clear cart?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.coffee,
            ),
          ),
          content: const Text(
            'All items will be removed from your cart.',
            style: TextStyle(fontSize: 13, color: AppColors.taupe, height: 1.5),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Keep items',
                style: TextStyle(color: AppColors.taupe),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Clear cart'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      store.clearCart();
    }
  }

  void _placeOrder(BuildContext context, AppStore store) {
    if (store.cartIsEmpty) return;
    final Order order = store.placeOrder();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => OrderSuccessScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    final List<CartItem> items = store.cartItems;
    final bool isEmpty = items.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'My cart',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isEmpty
                              ? 'Your bag is waiting for something tasty'
                              : '${store.cartCount} ${store.cartCount == 1 ? 'item' : 'items'} ready to order',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (!isEmpty)
                    TextButton(
                      onPressed: () => _confirmClear(context, store),
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: isEmpty
                  ? _EmptyCart(onBrowse: () => store.selectTab(0))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      children: <Widget>[
                        for (final CartItem item in items)
                          _CartLineCard(item: item, store: store),
                        const SizedBox(height: 4),
                        _ModeSelector(store: store),
                        const SizedBox(height: 12),
                        _DeliveryHint(store: store),
                        const SizedBox(height: 12),
                        _SummaryCard(store: store),
                      ],
                    ),
            ),
            if (!isEmpty)
              _CartFooter(
                store: store,
                onPlaceOrder: () => _placeOrder(context, store),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({required this.item, required this.store});

  final CartItem item;
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  item.dish.image,
                  width: 74,
                  height: 74,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 74,
                    height: 74,
                    color: AppColors.sand,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.restaurant,
                      size: 24,
                      color: AppColors.taupe,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.dish.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coffee,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => store.removeFromCart(item.dish.id),
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppColors.taupe,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rupiah(item.dish.price),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.taupe,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        QuantityStepper(
                          compact: true,
                          quantity: item.quantity,
                          onIncrement: () => store.increment(item.dish.id),
                          onDecrement: () => store.decrement(item.dish.id),
                        ),
                        const Spacer(),
                        Text(
                          rupiah(item.lineTotal),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.terracottaDeep,
                          ),
                        ),
                      ],
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
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: <Widget>[
          for (final DeliveryMode mode in DeliveryMode.values)
            Expanded(
              child: GestureDetector(
                onTap: () => store.setMode(mode),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: store.mode == mode
                        ? AppColors.coffee
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        mode.icon,
                        size: 17,
                        color: store.mode == mode
                            ? AppColors.honey
                            : AppColors.taupe,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        mode.label,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: store.mode == mode
                              ? Colors.white
                              : AppColors.taupe,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeliveryHint extends StatelessWidget {
  const _DeliveryHint({required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    if (store.mode == DeliveryMode.pickup) {
      return Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.storefront,
              size: 18,
              color: AppColors.terracottaDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pickup at ${RestaurantInfo.address}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkSoft,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final int remaining = RestaurantInfo.freeDeliveryThreshold - store.subtotal;
    final bool unlocked = remaining <= 0;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: unlocked
            ? const Color(0xFFE8F3E9)
            : AppColors.sand.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                unlocked ? Icons.check_circle_rounded : Icons.delivery_dining,
                size: 18,
                color: unlocked ? AppColors.leaf : AppColors.terracottaDeep,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  unlocked
                      ? 'Free delivery unlocked'
                      : 'Add ${rupiah(remaining)} more for free delivery',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: unlocked ? AppColors.leaf : AppColors.inkSoft,
                  ),
                ),
              ),
            ],
          ),
          if (!unlocked) ...<Widget>[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (store.subtotal / RestaurantInfo.freeDeliveryThreshold)
                    .clamp(0.0, 1.0)
                    .toDouble(),
                minHeight: 5,
                backgroundColor: Colors.white,
                color: AppColors.terracotta,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final bool freeDelivery = store.deliveryFee == 0;
    final String deliveryValue = store.mode == DeliveryMode.pickup
        ? '—'
        : (freeDelivery ? 'Free' : rupiah(store.deliveryFee));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: <Widget>[
          _SummaryRow(label: 'Subtotal', value: rupiah(store.subtotal)),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Delivery',
            value: deliveryValue,
            highlight: freeDelivery && store.mode == DeliveryMode.delivery,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            children: <Widget>[
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coffee,
                ),
              ),
              const Spacer(),
              Text(
                rupiah(store.total),
                style: const TextStyle(
                  fontSize: 18,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.taupe),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: highlight ? AppColors.leaf : AppColors.coffee,
          ),
        ),
      ],
    );
  }
}

class _CartFooter extends StatelessWidget {
  const _CartFooter({required this.store, required this.onPlaceOrder});

  final AppStore store;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 11, color: AppColors.taupe),
                    ),
                    Text(
                      rupiah(store.total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: onPlaceOrder,
                    child: const Text('Place order'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Demo checkout · no payment will be taken',
              style: TextStyle(fontSize: 10.5, color: AppColors.taupe),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.sand,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppColors.terracottaDeep,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Browse the menu and add something delicious.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.taupe),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: onBrowse,
                child: const Text('Browse menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
