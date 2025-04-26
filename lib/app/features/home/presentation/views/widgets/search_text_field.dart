import 'package:booksy/app/core/extensions/font_styles_extensions.dart';
import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:booksy/app/features/home/presentation/manager/cubit/books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarSection extends StatefulWidget {
  const SearchBarSection({super.key});

  @override
  State<SearchBarSection> createState() => _SearchBarSectionState();
}

class _SearchBarSectionState extends State<SearchBarSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.085,
          ),
        ),
      ),
      child: SearchBar(
        hintText: 'Search books...',
        controller: _searchController,
        hintStyle: WidgetStatePropertyAll(context.hintText),
        leading: const Icon(
          Icons.search,
          color: AppColors.secondaryColor,
        ),
        textStyle: WidgetStatePropertyAll(context.bodyMedium),
        overlayColor: WidgetStatePropertyAll(
            AppColors.secondaryColor.withValues(alpha: 0.02)),
        surfaceTintColor: WidgetStatePropertyAll(
            AppColors.primaryColor.withValues(alpha: 0.8)),
        textCapitalization: TextCapitalization.sentences,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: const BorderSide(
              color: AppColors.secondaryColor,
              width: 0.5,
            ),
          ),
        ),
        onChanged: (value) {
          context.read<BooksCubit>().searchBooks(value);
        },
        trailing: [
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppColors.secondaryColor,
            ),
            onPressed: () {
              _searchController.clear();
              context.read<BooksCubit>().clearSearch();
            },
          ),
        ],
      ),
    );
  }
}
