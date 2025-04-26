import 'package:equatable/equatable.dart';

import 'author.model.dart';
import 'formats.model.dart';

class Result extends Equatable {
  final int? id;
  final String? title;
  final List<Author>? authors;
  final List<String>? summaries;
  final List<dynamic>? translators;
  final List<String>? subjects;
  final List<String>? bookshelves;
  final List<String>? languages;
  final bool? copyright;
  final String? mediaType;
  final Formats? formats;
  final int? downloadCount;

  const Result({
    this.id,
    this.title,
    this.authors,
    this.summaries,
    this.translators,
    this.subjects,
    this.bookshelves,
    this.languages,
    this.copyright,
    this.mediaType,
    this.formats,
    this.downloadCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'] as int?,
        title: json['title'] as String?,
        authors: (json['authors'] as List<dynamic>?)
            ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
            .toList(),
        translators: json['translators'] as List<dynamic>?,
        languages: (json['languages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        subjects: (json['subjects'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        bookshelves: (json['bookshelves'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        summaries: (json['summaries'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        copyright: json['copyright'] as bool?,
        mediaType: json['media_type'] as String?,
        formats: json['formats'] == null
            ? null
            : Formats.fromJson(json['formats'] as Map<String, dynamic>),
        downloadCount: json['download_count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors?.map((e) => e.toJson()).toList(),
        'summaries': summaries,
        'translators': translators,
        'subjects': subjects,
        'bookshelves': bookshelves,
        'languages': languages,
        'copyright': copyright,
        'media_type': mediaType,
        'formats': formats?.toJson(),
        'download_count': downloadCount,
      };

  @override
  List<Object?> get props {
    return [
      id,
      title,
      authors,
      summaries,
      translators,
      subjects,
      bookshelves,
      languages,
      copyright,
      mediaType,
      formats,
      downloadCount,
    ];
  }
}
