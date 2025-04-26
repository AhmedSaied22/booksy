import 'package:hive/hive.dart';

part 'cached_book_model.g.dart';

@HiveType(typeId: 0)
class CachedBook extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> authors;

  @HiveField(3)
  final String? coverImageUrl;

  @HiveField(4)
  final String? summary;

  CachedBook({
    required this.id,
    required this.title,
    required this.authors,
    this.coverImageUrl,
    this.summary,
  });
}