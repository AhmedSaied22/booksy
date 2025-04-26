import 'package:equatable/equatable.dart';

import 'result.model.dart';

class Books extends Equatable {
  final int? count;
  final String? next;
  final dynamic previous;
  final List<Result>? results;

  const Books({this.count, this.next, this.previous, this.results});

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        count: json['count'] as int?,
        next: json['next'] as String?,
        previous: json['previous'] as dynamic,
        results: (json['results'] as List<dynamic>?)
            ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'count': count,
        'next': next,
        'previous': previous,
        'results': results?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [count, next, previous, results];
}
