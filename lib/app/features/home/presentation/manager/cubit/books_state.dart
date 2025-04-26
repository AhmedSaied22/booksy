part of 'books_cubit.dart';

sealed class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

final class BooksInitial extends BooksState {}

final class BooksLoadingState extends BooksState {}

final class BooksLoadingMoreState extends BooksState {
  final List<Book> previousBooks;
  const BooksLoadingMoreState(this.previousBooks);

  @override
  List<Object> get props => [previousBooks];
}

final class BooksFailureState extends BooksState {
  final String message;
  const BooksFailureState(this.message);

  @override
  List<Object> get props => [message];
}

final class BooksSuccessState extends BooksState {
  final BooksResult booksResult;
  const BooksSuccessState(this.booksResult);

  @override
  List<Object> get props => [booksResult];
}

final class BooksSearchingState extends BooksState {}

final class BooksSearchResultState extends BooksState {
  final String query;
  final List<Book> books;
  final bool hasReachedMax;
  
  const BooksSearchResultState({
    required this.query,
    required this.books,
    this.hasReachedMax = false,
  });
  
  @override
  List<Object> get props => [query, books, hasReachedMax];
}

final class BooksSearchLoadingMoreState extends BooksState {
  final List<Book> previousSearchResults;
  final String query;
  
  const BooksSearchLoadingMoreState(this.previousSearchResults, this.query);
  
  @override
  List<Object> get props => [previousSearchResults, query];
}

final class BooksOfflineState extends BooksState {
  final List<Book> cachedBooks;
  
  const BooksOfflineState(this.cachedBooks);
  
  @override
  List<Object> get props => [cachedBooks];
}