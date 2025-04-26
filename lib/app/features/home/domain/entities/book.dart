class Book {
  final int id;
  final String title;
  final List<String> authors;
  final String? coverImageUrl;
  final String? summary;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.coverImageUrl,
    this.summary,
  });
}