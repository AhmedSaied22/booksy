import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScrollToTopButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      color: AppColors.primaryColor,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white,
            size: 28.w,
          ),
        ),
      ),
    );
  }
}