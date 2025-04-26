import 'package:booksy/app/core/extensions/media_query_extensions.dart';
import 'package:booksy/app/core/layout/responsive.dart';
import 'package:booksy/app/core/ui/app_styles_fonts.dart';
import 'package:booksy/app/features/home/presentation/views/widgets/book%20section/book_card.dart';
import 'package:flutter/material.dart';

class BookListItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String summary;

  const BookListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.summary,
  });

  @override
  State<BookListItem> createState() => _BookListItemState();
}

class _BookListItemState extends State<BookListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: BookCard(
        imageUrl: widget.imageUrl,
        title: widget.title,
        author: widget.author,
        summary: widget.summary,
        isExpanded: _isExpanded,
        onToggleExpand: _toggleExpand,
        imageWidth: context.widthPercent(0.18),
        imageHeight: context.heightPercent(0.15),
        titleFontSize: AppFonts.sizes.s16,
        summaryMaxLines: 3,
      ),
      tablet: BookCard(
        imageUrl: widget.imageUrl,
        title: widget.title,
        author: widget.author,
        summary: widget.summary,
        isExpanded: _isExpanded,
        onToggleExpand: _toggleExpand,
        imageWidth: context.widthPercent(0.13),
        imageHeight: context.heightPercent(0.18),
        titleFontSize: AppFonts.sizes.s16,
        summaryMaxLines: 4,
      ),
      desktop: BookCard(
        imageUrl: widget.imageUrl,
        title: widget.title,
        author: widget.author,
        summary: widget.summary,
        isExpanded: _isExpanded,
        onToggleExpand: _toggleExpand,
        imageWidth: context.widthPercent(0.09),
        imageHeight: context.heightPercent(0.22),
        titleFontSize: AppFonts.sizes.s18,
        summaryMaxLines: 5,
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
