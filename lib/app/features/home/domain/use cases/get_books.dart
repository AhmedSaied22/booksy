import 'package:booksy/app/core/error/failure.dart';
import 'package:booksy/app/features/home/domain/entities/book_result.dart';
import 'package:booksy/app/features/home/domain/repositories/books_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
@injectable

class GetBooksuseCase {
  final BooksRepository booksRepository;
  
  GetBooksuseCase(this.booksRepository);
  
 Future<Either<Failure, BooksResult>> call({int page = 1, String? query}) async {
  return await booksRepository.getBooks(page: page, query: query);
}
}