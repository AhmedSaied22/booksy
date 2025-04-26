import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String? name;
  final int? birthYear;
  final int? deathYear;

  const Author({this.name, this.birthYear, this.deathYear});

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json['name'] as String?,
        birthYear: json['birth_year'] as int?,
        deathYear: json['death_year'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'birth_year': birthYear,
        'death_year': deathYear,
      };

  @override
  List<Object?> get props => [name, birthYear, deathYear];
}
