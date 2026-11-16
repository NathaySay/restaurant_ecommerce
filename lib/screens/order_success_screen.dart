import 'package:balancika_demo/core/format.dart';
import 'package:balancika_demo/models/order.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              child: Column(
                children: <Widget>[
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.6, end: 1),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutBack,
                    builder:
                        (BuildContext context, double value, Widget? child) {
                          return Transform.scale(scale: value, child: child);
                        },
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: <Color>[AppColors.leaf, Color(0xFF6AAE72)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.leaf.withValues(alpha: 0.30),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Order placed!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.id} · ${order.mode.label}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.taupe,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.mode == DeliveryMode.delivery
                        ? 'Our kitchen is preparing your order. It will arrive '
                              'in 25–35 minutes.'
                        : 'Our kitchen is preparing your order. Pick it up in '
                              'about 15 minutes.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  _ReceiptCard(order: order),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        store.selectTab(0);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back to menu'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () {
                      store.selectTab(2);
                      Navigator.of(context).pop();
                    },
                    child: const Text('View order history'),
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

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _ReceiptMeta(
                  label: 'ESTIMATED TIME',
                  value: order.mode == DeliveryMode.delivery
                      ? '25–35 min'
                      : '15 min',
                ),
              ),
              Container(width: 1, height: 34, color: AppColors.stroke),
              Expanded(
                child: _ReceiptMeta(
                  label: 'TOTAL',
                  value: rupiah(order.total),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(),
          ),
          for (final OrderLine line in order.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${line.quantity} × ${line.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rupiah(line.total),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(),
          ),
          Row(
            children: <Widget>[
              const Text(
                'Payment',
                style: TextStyle(fontSize: 11.5, color: AppColors.taupe),
              ),
              const Spacer(),
              Text(
                order.mode == DeliveryMode.delivery
                    ? 'Cash on delivery'
                    : 'Pay at pickup',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coffee,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptMeta extends StatelessWidget {
  const _ReceiptMeta({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.taupe,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.coffee,
          ),
        ),
      ],
    );
  }
}
