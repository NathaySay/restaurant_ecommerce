import 'package:balancika_demo/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

class IconCircleButton extends StatelessWidget {
  const IconCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 42,
    this.iconSize = 20,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.coffee,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final Widget button = Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
