import 'package:booksy/app/features/home/data/models/local%20data%20models/cached_book_model.dart';
import 'package:hive/hive.dart';
part 'cached_books_result_model.g.dart';

@HiveType(typeId: 1)
class CachedBooksResult extends HiveObject {
  @HiveField(0)
  final int count;

  @HiveField(1)
  final List<CachedBook> books;

  @HiveField(2)
  final String? next;

  @HiveField(3)
  final String? previous;

  @HiveField(4)
  final String? query;

  @HiveField(5)
  final int page;

  @HiveField(6)
  final DateTime timestamp;

  CachedBooksResult({
    required this.count,
    required this.books,
    this.next,
    this.previous,
    this.query,
    required this.page,
    required this.timestamp,
  });
}