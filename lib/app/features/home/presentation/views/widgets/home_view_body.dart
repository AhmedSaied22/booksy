import 'package:booksy/app/core/extensions/font_styles_extensions.dart';
import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:booksy/app/core/utils/app_strings.dart';
import 'package:booksy/app/features/home/presentation/manager/cubit/books_cubit.dart';
import 'package:booksy/app/features/home/presentation/views/widgets/book%20section/book_list_view.dart';
import 'package:booksy/app/features/home/presentation/views/widgets/scroll_up_to_top.dart';
import 'package:booksy/app/features/home/presentation/views/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final ScrollController _scrollController = ScrollController();
  bool _showWelcome = true;
  bool _showScrollToTop = false;
  static const double welcomeThreshold = 100.0;
  static const double scrollToTopThreshold = 300.0;

  @override
  void initState() {
    context.read<BooksCubit>().getBooks();
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Hide welcome messages when user scrolls to achieve better UX
    final showWelcome = _scrollController.offset <= welcomeThreshold;
    if (showWelcome != _showWelcome) {
      setState(() {
        _showWelcome = showWelcome;
      });
    }

    final showScrollToTop = _scrollController.offset >= scrollToTopThreshold;
    if (showScrollToTop != _showScrollToTop) {
      setState(() {
        _showScrollToTop = showScrollToTop;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              switchInCurve: Curves.fastEaseInToSlowEaseOut,
              switchOutCurve: Curves.fastLinearToSlowEaseIn,
              child: _showWelcome
                  ? Padding(
                      key: const ValueKey('welcome'),
                      padding: EdgeInsets.only(
                          right: 16.w, left: 16.w, bottom: 8.h, top: 18.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppStrings.welcomeText,
                                    style: context.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  2.verticalSpace,
                                  Text(
                                    AppStrings.welcomeSubText,
                                    style: context.bodyLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                          ),
                          Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.secondaryColor,
                            size: 32.w,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SearchBarSection(),
            Expanded(
              child: RefreshIndicator(
                 onRefresh: () => context.read<BooksCubit>().refreshBooks(),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: 16.h),
                    ),
                    const BookListView(),
                  ],
                ),
              ),
            ),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          right: 16.w,
          bottom: _showScrollToTop ? 16.h : -60.h, // Animate in/out from bottom
          child: ScrollToTopButton(
            onPressed: _scrollToTop,
          ),
        ),
      ],
    );
  }
}
