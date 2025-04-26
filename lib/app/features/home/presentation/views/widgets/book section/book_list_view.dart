import 'package:booksy/app/core/extensions/font_styles_extensions.dart';
import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:booksy/app/features/home/domain/entities/book.dart';
import 'package:booksy/app/features/home/presentation/views/widgets/book%20section/book_list_item.dart';
import 'package:booksy/app/features/home/presentation/manager/cubit/books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookListView extends StatelessWidget {
  const BookListView({super.key});

  // Constants
  static const int _loadingSkeletonCount = 5;
  static const int _searchingSkeletonCount = 3;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(
      builder: (context, state) {
        return switch (state) {
          BooksLoadingState() => const _LoadingView(itemCount: _loadingSkeletonCount),
          BooksSearchingState() => const _LoadingView(itemCount: _searchingSkeletonCount),
          BooksFailureState() => _ErrorView(message: state.message),
          BooksOfflineState() => _OfflineView(cachedBooks: state.cachedBooks),
          BooksSuccessState() => _BooksListView(
              books: state.booksResult.books,
              hasReachedMax: context.read<BooksCubit>().hasReachedMax,
              onNeedMoreData: () => context.read<BooksCubit>().loadMoreBooks(),
            ),
          BooksLoadingMoreState() => _BooksListView(
              books: state.previousBooks,
              showLoadingIndicator: true,
              hasReachedMax: context.read<BooksCubit>().hasReachedMax,
              onNeedMoreData: () => context.read<BooksCubit>().loadMoreBooks(),
            ),
          BooksSearchResultState() => _SearchResultView(
              books: state.books,
              query: state.query,
              hasReachedMax: state.hasReachedMax,
              onNeedMoreData: () => context.read<BooksCubit>().loadMoreSearchResults(),
            ),
          _ => const SliverToBoxAdapter(child: SizedBox.shrink())
        };
      },
    );
  }
}

// Extracted widget for loading state with skeletons
class _LoadingView extends StatelessWidget {
  final int itemCount;

  const _LoadingView({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Skeletonizer(
        enabled: true,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (_, __) => const _SkeletonBookItem(),
        ),
      ),
    );
  }
}

// Extracted widget for error state
class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.read<BooksCubit>().refreshBooks(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extracted widget for offline state
class _OfflineView extends StatelessWidget {
  final List<Book> cachedBooks;

  const _OfflineView({required this.cachedBooks});

  @override
  Widget build(BuildContext context) {
    if (cachedBooks.isEmpty) {
      return const _EmptyOfflineMessage();
    }

    return SliverList.builder(
      itemCount: cachedBooks.length + 1, // +1 for the offline banner
      itemBuilder: (context, index) {
        // Offline banner at the top
        if (index == 0) {
          return _OfflineBanner(
            onTryAgain: () => context.read<BooksCubit>().refreshBooks(),
          );
        }
        
        // Adjust index for books
        final bookIndex = index - 1;
        final book = cachedBooks[bookIndex];
        return _CachedBookItem(book: book);
      },
    );
  }
}

// Offline banner with retry option
class _OfflineBanner extends StatelessWidget {
  final VoidCallback onTryAgain;
  
  const _OfflineBanner({required this.onTryAgain});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryTextColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.secondaryColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are offline. Showing cached books.',
              style: context.hintText.copyWith(color: Colors.orange[800]),
            ),
          ),
          TextButton(
            onPressed: onTryAgain,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyOfflineMessage extends StatelessWidget {
  const _EmptyOfflineMessage();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
           const   Icon(
                Icons.wifi_off,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'You are offline and no cached books are available.',
                textAlign: TextAlign.center,
                style: context.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.read<BooksCubit>().refreshBooks(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extracted widget for cached book item
class _CachedBookItem extends StatelessWidget {
  final Book book;

  const _CachedBookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BookListItem(
          imageUrl: book.coverImageUrl ?? '',
          title: book.title,
          author: book.authors.join(', '),
          summary: book.summary ?? '',
        ),
        const Positioned(
          top: 8,
          right: 8,
          child: _CachedBadge(),
        ),
      ],
    );
  }
}

// Extracted widget for books list with pagination
class _BooksListView extends StatelessWidget {
  final List<Book> books;
  final bool showLoadingIndicator;
  final bool hasReachedMax;
  final VoidCallback onNeedMoreData;
  static const double _scrollThreshold = 0.8;

  const _BooksListView({
    required this.books,
    this.showLoadingIndicator = false,
    required this.hasReachedMax,
    required this.onNeedMoreData,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const _EmptyBooksView();
    }
    
    return SliverList.builder(
      itemCount: books.length + (showLoadingIndicator ? 1 : 0),
      itemBuilder: (context, index) {
        // Check if we need to load more books
        _checkAndLoadMoreBooks(index, books.length);
        
        // Loading indicator at the end
        if (index == books.length && showLoadingIndicator) {
          return const Skeletonizer(
            enabled: true,
            child: _SkeletonBookItem(),
          );
        }
        
        // Regular book items
        if (index < books.length) {
          return _BookItem(book: books[index]);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  void _checkAndLoadMoreBooks(int index, int totalBooks) {
    if (index >= totalBooks * _scrollThreshold &&
        index < totalBooks &&
        !hasReachedMax) {
      onNeedMoreData();
    }
  }
}

// Empty state for books
class _EmptyBooksView extends StatelessWidget {
  const _EmptyBooksView();
  
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.library_books_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No books available',
                style: context.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching for a different book or check back later',
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extracted widget for search results
class _SearchResultView extends StatelessWidget {
  final List<Book> books;
  final String query;
  final bool hasReachedMax;
  final VoidCallback onNeedMoreData;
  static const double _scrollThreshold = 0.8;

  const _SearchResultView({
    required this.books,
    required this.query,
    required this.hasReachedMax,
    required this.onNeedMoreData,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return _EmptySearchResult(query: query);
    }

    return SliverList.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        // Check if we need to load more results
        _checkAndLoadMoreResults(index, books.length);
        
        return _BookItem(book: books[index]);
      },
    );
  }
  
  void _checkAndLoadMoreResults(int index, int totalBooks) {
    if (index >= totalBooks * _scrollThreshold &&
        index < totalBooks &&
        !hasReachedMax) {
      onNeedMoreData();
    }
  }
}

// Extracted widget for empty search result
class _EmptySearchResult extends StatelessWidget {
  final String query;

  const _EmptySearchResult({required this.query});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No books found for "$query"',
                style: context.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => context.read<BooksCubit>().clearSearch(),
                child: const Text('Clear Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extracted widget for book item
class _BookItem extends StatelessWidget {
  final Book book;

  const _BookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return BookListItem(
      imageUrl: book.coverImageUrl ?? '',
      title: book.title,
      author: book.authors.join(', '),
      summary: book.summary ?? '',
    );
  }
}

// Skeleton book item for loading states
class _SkeletonBookItem extends StatelessWidget {
  const _SkeletonBookItem();

  @override
  Widget build(BuildContext context) {
    return const BookListItem(
      imageUrl: '',
      title: 'Book Title Example',
      author: 'Author Name',
      summary:
          'This is a placeholder summary for the book that will be replaced with actual content.',
    );
  }
}

// Widget for cached badge
class _CachedBadge extends StatelessWidget {
  const _CachedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Cached',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}