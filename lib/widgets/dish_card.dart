import 'package:balancika_demo/core/format.dart';
import 'package:balancika_demo/models/dish.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:balancika_demo/widgets/icon_circle_button.dart';
import 'package:material_ui/material_ui.dart';

class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.dish,
    required this.isFavorite,
    required this.onTap,
    required this.onAdd,
    required this.onToggleFavorite,
  });

  final Dish dish;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F2D1B12),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 130,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.asset(
                          dish.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.sand,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.restaurant,
                              color: AppColors.taupe,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      if (dish.tag != null)
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              dish.tag!,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.coffee,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconCircleButton(
                          icon: isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          iconColor: isFavorite
                              ? AppColors.terracotta
                              : AppColors.coffee,
                          size: 30,
                          iconSize: 16,
                          backgroundColor: Colors.white.withValues(alpha: 0.92),
                          tooltip: isFavorite
                              ? 'Remove from favorites'
                              : 'Save to favorites',
                          onPressed: onToggleFavorite,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dish.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coffee,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            dish.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coffee,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '(${dish.reviewCount})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.taupe,
                              ),
                            ),
                          ),
                          Text(
                            '${dish.prepMinutes} min',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.taupe,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              rupiah(dish.price),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.terracottaDeep,
                              ),
                            ),
                          ),
                          Tooltip(
                            message: 'Add to cart',
                            child: Material(
                              color: AppColors.terracotta,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: onAdd,
                                child: const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 18,
                                    color: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
