import 'package:booksy/app/features/home/presentation/views/widgets/book%20section/book_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String summary;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final double imageWidth;
  final double imageHeight;
  final double titleFontSize;
  final int summaryMaxLines;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.summary,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.imageWidth,
    required this.imageHeight,
    required this.titleFontSize,
    required this.summaryMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookImage(
              imageUrl: imageUrl,
              width: imageWidth,
              height: imageHeight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BookInfo(
                title: title,
                author: author,
                summary: summary,
                isExpanded: isExpanded,
                onToggleExpand: onToggleExpand,
                titleFontSize: titleFontSize,
                summaryMaxLines: summaryMaxLines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const _BookImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
