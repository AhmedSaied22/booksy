import 'package:booksy/app/core/extensions/media_query_extensions.dart';
import 'package:booksy/app/core/images/app_images.dart';
import 'package:booksy/app/features/splash/presentation/views/widgets/splash_content_section.dart';
import 'package:booksy/app/features/splash/presentation/views/widgets/splash_image.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 8),
              child: Transform.translate(
                offset: Offset(-context.screenWidth * 0.1, 0),
                child: SplashImage(
                  imagePath: Assets.manSplashVector,
                  imageHeight: context.screenHeight * 0.2,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 8),
              child: Transform.translate(
                offset: Offset(context.screenWidth * 0.1, 0),
                child: SplashImage(
                  imagePath: Assets.womanSplashVector,
                  imageHeight: context.screenHeight * 0.2,
                ),
              ),
            ),
          ),
          SplashContentSection(),
        ],
      ),
    );
  }
}
