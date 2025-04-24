import 'package:booksy/app/core/extensions/media_query_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({
    super.key,
    required this.imagePath,
    this.imageHeight,
  });
  final String imagePath;
  final double? imageHeight;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      height: imageHeight ?? context.screenHeight * 0.45,
    );
  }
}
