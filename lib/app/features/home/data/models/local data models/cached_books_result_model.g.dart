// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_books_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedBooksResultAdapter extends TypeAdapter<CachedBooksResult> {
  @override
  final int typeId = 1;

  @override
  CachedBooksResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedBooksResult(
      count: fields[0] as int,
      books: (fields[1] as List).cast<CachedBook>(),
      next: fields[2] as String?,
      previous: fields[3] as String?,
      query: fields[4] as String?,
      page: fields[5] as int,
      timestamp: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedBooksResult obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.books)
      ..writeByte(2)
      ..write(obj.next)
      ..writeByte(3)
      ..write(obj.previous)
      ..writeByte(4)
      ..write(obj.query)
      ..writeByte(5)
      ..write(obj.page)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedBooksResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
