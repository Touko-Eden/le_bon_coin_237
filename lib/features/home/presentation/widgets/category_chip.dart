// category_chip.dart
import 'package:flutter/material.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.icon,
    required this.name,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: _getIconColor(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(Color bgColor) {
    if (bgColor == AppColors.illustrationYellow) return const Color(0xFFFBC02D);
    if (bgColor == AppColors.illustrationPink) return AppColors.primary;
    if (bgColor == AppColors.illustrationBlue) return const Color(0xFF03A9F4);
    if (bgColor == AppColors.illustrationPeach) return const Color(0xFFFF6F00);
    if (bgColor == AppColors.illustrationMint) return const Color(0xFF00897B);
    return AppColors.textPrimary;
  }
}


