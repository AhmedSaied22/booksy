import 'package:booksy/app/core/error/failure.dart';
import 'package:booksy/app/features/home/data/models/books/author.model.dart';
import 'package:booksy/app/features/home/data/models/books/books.model.dart';
import 'package:booksy/app/features/home/data/models/books/formats.model.dart';
import 'package:booksy/app/features/home/data/models/books/result.model.dart';
import 'package:booksy/app/features/home/data/models/local%20data%20models/cached_book_model.dart';
import 'package:booksy/app/features/home/data/models/local%20data%20models/cached_books_result_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class BooksLocalDataSource {
  final Box<CachedBooksResult> _booksBox;
  
  BooksLocalDataSource() : _booksBox = Hive.box<CachedBooksResult>('books_results');
  
  Future<void> cacheBooks(Books booksModel, {int page = 1, String? query}) async {
    final cachedBooks = booksModel.results?.map((book) => CachedBook(
      id: book.id ?? 0,
      title: book.title ?? '',
      authors: (book.authors ?? []).map((author) => author.name ?? '').toList(),
      coverImageUrl: book.formats?.imageJpeg,
      summary: (book.summaries != null && book.summaries!.isNotEmpty) 
          ? book.summaries!.first 
          : null,
    )).toList() ?? [];
    
    final cachedResult = CachedBooksResult(
      count: booksModel.count ?? 0,
      books: cachedBooks,
      next: booksModel.next,
      previous: booksModel.previous,
      query: query,
      page: page,
      timestamp: DateTime.now(),
    );
    
    final key = query != null ? '${query}_$page' : 'page_$page';
    await _booksBox.put(key, cachedResult);
  }
  
  Books? getCachedBooks({int page = 1, String? query}) {
    try {
      final key = query != null ? '${query}_$page' : 'page_$page';
      final cachedResult = _booksBox.get(key);
      
      if (cachedResult == null) {
        return null;
      }
      
      return Books(
        count: cachedResult.count,
        next: cachedResult.next,
        previous: cachedResult.previous,
        results: cachedResult.books.map((book) => 
          Result(
            id: book.id,
            title: book.title,
            authors: book.authors.map((name) => Author(name: name)).toList(),
            formats: Formats(imageJpeg: book.coverImageUrl),
            summaries: book.summary != null ? [book.summary!] : [],
          )
        ).toList(),
      );
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }
  
  // Get all cached results for a specific query
  List<Books> getAllCachedBooksForQuery(String query) {
    try {
      final results = <Books>[];
      
      for (var key in _booksBox.keys) {
        if (key.toString().startsWith('${query}_')) {
          final cachedResult = _booksBox.get(key);
          if (cachedResult != null) {
            results.add(Books(
              count: cachedResult.count,
              next: cachedResult.next,
              previous: cachedResult.previous,
              results: cachedResult.books.map((book) => 
                Result(
                  id: book.id,
                  title: book.title,
                  authors: book.authors.map((name) => Author(name: name)).toList(),
                  formats: Formats(imageJpeg: book.coverImageUrl),
                  summaries: book.summary != null ? [book.summary!] : [],
                )
              ).toList(),
            ));
          }
        }
      }
      
      return results;
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }
  
  Future<void> clearOldCache({Duration maxAge = const Duration(days: 7)}) async {
    final now = DateTime.now();
    
    for (var key in _booksBox.keys) {
      final cachedResult = _booksBox.get(key);
      if (cachedResult != null) {
        final age = now.difference(cachedResult.timestamp);
        if (age > maxAge) {
          await _booksBox.delete(key);
        }
      }
    }
  }
}