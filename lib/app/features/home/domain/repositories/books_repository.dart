import 'package:booksy/app/core/error/failure.dart';
import 'package:booksy/app/features/home/domain/entities/book_result.dart';
import 'package:dartz/dartz.dart';

abstract class BooksRepository {
  Future<Either<Failure, BooksResult>> getBooks({int page = 1, String? query});
}