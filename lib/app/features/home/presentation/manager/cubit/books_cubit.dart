import 'dart:async';
import 'package:booksy/app/features/home/domain/entities/book.dart';
import 'package:booksy/app/features/home/domain/entities/book_result.dart';
import 'package:booksy/app/features/home/domain/use%20cases/get_books.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'books_state.dart';

@injectable
class BooksCubit extends Cubit<BooksState> {
  final GetBooksuseCase _getBooksUseCase;
  final Connectivity _connectivity;
  
  // Main book list state
  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<Book> _allBooks = [];
  
  // Search state
  int _searchPage = 1;
  bool _searchHasReachedMax = false;
  List<Book> _searchResults = [];
  String _searchQuery = '';
  
  bool _isLoading = false;
  
  bool _isOffline = false;
  
  Timer? _debounceTimer;
  StreamSubscription? _connectivitySubscription;
  
  bool get hasReachedMax => _hasReachedMax;
  bool get isOffline => _isOffline;

  BooksCubit(this._getBooksUseCase, this._connectivity) : super(BooksInitial()) {
    _initConnectivityMonitoring();
  }

  void _initConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _connectivity.checkConnectivity().then(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _isOffline = results.isEmpty || results.every((result) => result == ConnectivityResult.none);
    
    if (_isOffline && _allBooks.isNotEmpty && state is! BooksOfflineState) {
      emit(BooksOfflineState(_allBooks));
    }
  }

  Future<void> refreshBooks() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isOffline = connectivityResult.isEmpty || 
                 connectivityResult.every((result) => result == ConnectivityResult.none);
    if (_isOffline) {
      emit(BooksOfflineState(_allBooks));
      return;
    }
    await getBooks(page: 1, forceRefresh: true);
  }

  Future<void> getBooks({int page = 1, bool forceRefresh = false}) async {
    if (_isLoading) return;
    _prepareForLoading(page, forceRefresh);    
    try {
      _isLoading = true;
      final result = await _getBooksUseCase(page: page);
      
      result.fold(
        _handleFailure,
        (booksResult) => _handleSuccess(booksResult, page, forceRefresh),
      );
    } finally {
      _isLoading = false;
    }
  }

  /// Loads more books when user scrolls to bottom
  Future<void> loadMoreBooks() async {
    if (_hasReachedMax || _isLoading) return;
    await getBooks(page: _currentPage + 1);
  }

  void searchBooks(String query) {
    _debounceTimer?.cancel();
    _searchQuery = query;

    if (query.isEmpty) {
      clearSearch();
      return;
    }
    
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _resetSearchState();
      _searchBooksFromApi(query, _searchPage);
    });
  }

  Future<void> loadMoreSearchResults() async {
    if (_searchHasReachedMax || _isLoading || _searchQuery.isEmpty) return;
    await _searchBooksFromApi(_searchQuery, _searchPage + 1);
  }

  void clearSearch() {
    _resetSearchState();
    _debounceTimer?.cancel();

    emit(BooksSuccessState(_createBooksResult()));
  }


  void _prepareForLoading(int page, bool forceRefresh) {
    if (page == 1) {
      _currentPage = 1;
      if (!forceRefresh) {
        _allBooks = [];
      }
      _hasReachedMax = false;
      emit(BooksLoadingState());
    } else {
      emit(BooksLoadingMoreState(_allBooks));
    }
  }

  void _handleFailure(failure) {
    if (_isOffline) {
      emit(BooksOfflineState(_allBooks));
    } else {
      emit(BooksFailureState(failure.message));
    }
  }

  void _handleSuccess(BooksResult booksResult, int page, bool forceRefresh) {
    _currentPage = page;
    _updateHasReachedMax(booksResult);
    _updateBooksList(booksResult, page, forceRefresh);
    
    final updatedResult = _createBooksResult(booksResult);
    emit(BooksSuccessState(updatedResult));
  }

  void _updateHasReachedMax(BooksResult booksResult) {
    _hasReachedMax = booksResult.books.isEmpty || booksResult.next == null;
  }

  void _updateBooksList(BooksResult booksResult, int page, bool forceRefresh) {
    if (forceRefresh && page == 1) {
      _allBooks = booksResult.books;
    } else {
      _allBooks = [..._allBooks, ...booksResult.books];
    }
  }

  BooksResult _createBooksResult([BooksResult? original]) {
    return BooksResult(
      count: original?.count ?? _allBooks.length,
      next: original?.next ?? (_currentPage < (_allBooks.length / 20).ceil() ? 'next_page' : null),
      previous: original?.previous ?? (_currentPage > 1 ? 'previous_page' : null),
      books: _allBooks,
    );
  }

  void _resetSearchState() {
    _searchPage = 1;
    _searchResults = [];
    _searchHasReachedMax = false;
  }

  Future<void> _searchBooksFromApi(String query, int page) async {
    if (_isLoading) return;

    _emitSearchLoadingState(page);
    
    try {
      _isLoading = true;
      final result = await _getBooksUseCase(page: page, query: query);
      
      result.fold(
        (failure) => emit(BooksFailureState(failure.message)),
        (booksResult) => _handleSearchSuccess(booksResult, page, query),
      );
    } finally {
      _isLoading = false;
    }
  }

  void _emitSearchLoadingState(int page) {
    if (page == 1) {
      emit(BooksSearchingState());
    } else {
      emit(BooksSearchLoadingMoreState(_searchResults, _searchQuery));
    }
  }

  void _handleSearchSuccess(BooksResult booksResult, int page, String query) {
    _searchPage = page;
    _searchHasReachedMax = booksResult.books.isEmpty || booksResult.next == null;
    _searchResults = [..._searchResults, ...booksResult.books];
    
    emit(BooksSearchResultState(
      query: query,
      books: _searchResults,
      hasReachedMax: _searchHasReachedMax,
    ));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}