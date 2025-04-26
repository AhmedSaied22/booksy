import 'package:booksy/app/core/extensions/font_styles_extensions.dart';
import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:booksy/app/core/ui/app_styles_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookInfo extends StatelessWidget {
  final String title;
  final String author;
  final String summary;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final double titleFontSize;
  final int summaryMaxLines;

  const BookInfo({
    super.key,
    required this.title,
    required this.author,
    required this.summary,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.titleFontSize,
    required this.summaryMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    final text =
        summary.trim().isEmpty ? 'No summary available.' : summary.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textStyle(
            size: titleFontSize,
            weight: AppFonts.weights.bold,
            fontFamily: AppFonts.primaryFont,
          ),
        ),
        4.verticalSpace,
        Text(
          author,
          style:
              context.bodyMedium.copyWith(color: AppColors.secondaryTextColor),
        ),
        8.verticalSpace,
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Text(
            text,
            maxLines: isExpanded ? null : summaryMaxLines,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: context.hintText,
          ),
        ),
        4.verticalSpace,
        GestureDetector(
          onTap: onToggleExpand,
          child: Text(
            isExpanded ? 'See Less' : 'See More...',
            style: context.hintText.copyWith(
                color: AppColors.secondaryColor.withValues(alpha: 0.6)),
          ),
        ),
      ],
    );
  }
}
