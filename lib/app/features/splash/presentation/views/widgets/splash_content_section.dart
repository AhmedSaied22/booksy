import 'package:booksy/app/core/extensions/font_styles_extensions.dart';
import 'package:booksy/app/core/images/app_images.dart';
import 'package:booksy/app/core/routes/routes_name.dart';
import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:booksy/app/core/utils/app_strings.dart';
import 'package:booksy/app/features/splash/presentation/views/widgets/splash_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashContentSection extends StatefulWidget {
  const SplashContentSection({super.key});

  @override
  State<SplashContentSection> createState() => _SplashContentSectionState();
}

class _SplashContentSectionState extends State<SplashContentSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _bookOffset;
  late Animation<Offset> _syOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _bookOffset = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _syOffset = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20.h,
        children: [
          SplashImage(imagePath: Assets.mainSplashVector),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _bookOffset,
                child: Text(
                  "BOOK",
                  style: context.headingLarge,
                ),
              ),
              SlideTransition(
                position: _syOffset,
                child: Text(
                  "SY",
                  style: context.headingLarge.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Text(
              AppStrings.splashSubTitle,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: navigateToHome,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Start",
              style: context.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacementNamed(RoutesName.home);
  }
}
