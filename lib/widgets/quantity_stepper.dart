import 'package:balancika_demo/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double buttonSize = compact ? 28 : 36;

    return Container(
      padding: EdgeInsets.all(compact ? 2 : 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            size: buttonSize,
            tooltip: 'Decrease quantity',
            onTap: onDecrement,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w600,
                color: AppColors.coffee,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            size: buttonSize,
            tooltip: 'Increase quantity',
            onTap: onIncrement,
            filled: true,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.size,
    required this.tooltip,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final double size;
  final String tooltip;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: filled ? AppColors.terracotta : Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: size * 0.48,
              color: filled ? Colors.white : AppColors.coffee,
            ),
          ),
        ),
      ),
    );
  }
}
