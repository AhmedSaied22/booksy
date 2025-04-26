import 'package:booksy/app/features/home/domain/entities/book.dart';

class BooksResult {
  final int count;
  final String? next;
  final String? previous;
  final List<Book> books;

  BooksResult({
    required this.count,
    this.next,
    this.previous,
    required this.books,
  });
}