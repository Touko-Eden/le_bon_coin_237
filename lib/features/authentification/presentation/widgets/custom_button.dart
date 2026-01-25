
// custom_button.dart
import 'package:flutter/material.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return _buildOutlinedButton(context);
    }
    return _buildElevatedButton(context);
  }

  Widget _buildElevatedButton(BuildContext context) {
    return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 56,
        child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: textColor ?? AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.textWhite,
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
        const SizedBox(width: 8),
    Icon(icon, size: 20),
    ],
    ],
    ),
    ),
    );
    }

  Widget _buildOutlinedButton(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: backgroundColor ?? AppColors.primary,
            side: BorderSide(
              color: backgroundColor ?? AppColors.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: backgroundColor ?? AppColors.primary,
              strokeWidth: 2,
            ),
          )
              : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              if (icon != null) ...[
          Icon(icon, size: 20),
      const SizedBox(width: 8),
      ],
    Text(
    text,
    style: TextStyle(
    fontSize: fontSize ?? 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    ],
    ),
    ),
    );
  }
}