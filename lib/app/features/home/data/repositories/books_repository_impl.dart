import 'package:booksy/app/core/error/failure.dart';
import 'package:booksy/app/features/home/data/data_sources/books_remote_data_source.dart';
import 'package:booksy/app/features/home/data/data_sources/books_local_data_source.dart';
import 'package:booksy/app/features/home/domain/entities/book.dart';
import 'package:booksy/app/features/home/domain/entities/book_result.dart';
import 'package:booksy/app/features/home/domain/repositories/books_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@Injectable(as: BooksRepository)
class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remoteDataSource;
  final BooksLocalDataSource localDataSource;
  final Connectivity connectivity;

  BooksRepositoryImpl(
    this.remoteDataSource, 
    this.localDataSource,
    this.connectivity,
  );

  @override
  Future<Either<Failure, BooksResult>> getBooks({int page = 1, String? query}) async {
    final connectivityResult = await connectivity.checkConnectivity();
    final bool isConnected = connectivityResult != ConnectivityResult.none;

    if (isConnected) {
      try {
        final booksModel = await remoteDataSource.getBooks(page: page, query: query);
        
        // Cache the results
        await localDataSource.cacheBooks(booksModel, page: page, query: query);
        final booksResult = BooksResult(
          count: booksModel.count ?? 0,  
          books: (booksModel.results ?? [])
              .map((result) => Book(
                    id: result.id ?? 0,
                    title: result.title ?? '',
                    authors: (result.authors ?? [])
                        .map((author) => author.name ?? '')
                        .toList(),
                    coverImageUrl: result.formats?.imageJpeg,
                    summary:
                        (result.summaries != null && result.summaries!.isNotEmpty)
                            ? result.summaries!.first
                            : null,
                  ))
              .toList(),
          next: booksModel.next,
          previous: booksModel.previous, 
        );
        return Right(booksResult);
      } catch (e) {
        // get from cahe if server fail
        return _getCachedBooks(page: page, query: query);
      }
    } else {
      //offline, get from cache
      return _getCachedBooks(page: page, query: query);
    }
  }

  Future<Either<Failure, BooksResult>> _getCachedBooks({int page = 1, String? query}) async {
    try {
      final cachedBooks = localDataSource.getCachedBooks(page: page, query: query);
      
      if (cachedBooks != null) {
        final booksResult = BooksResult(
          count: cachedBooks.count ?? 0,  
          books: (cachedBooks.results ?? [])
              .map((result) => Book(
                    id: result.id ?? 0,
                    title: result.title ?? '',
                    authors: (result.authors ?? [])
                        .map((author) => author.name ?? '')
                        .toList(),
                    coverImageUrl: result.formats?.imageJpeg,
                    summary:
                        (result.summaries != null && result.summaries!.isNotEmpty)
                            ? result.summaries!.first
                            : null,
                  ))
              .toList(),
          next: cachedBooks.next,
          previous: cachedBooks.previous, 
        );
        return Right(booksResult);
      } else {
        return Left(CacheFailure(message: 'No cached data available'));
      }
    } catch (e) {
      return Left(e is Failure ? e : CacheFailure(message: e.toString()));
    }
  }
}