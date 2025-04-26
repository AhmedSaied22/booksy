// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedBookAdapter extends TypeAdapter<CachedBook> {
  @override
  final int typeId = 0;

  @override
  CachedBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedBook(
      id: fields[0] as int,
      title: fields[1] as String,
      authors: (fields[2] as List).cast<String>(),
      coverImageUrl: fields[3] as String?,
      summary: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CachedBook obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authors)
      ..writeByte(3)
      ..write(obj.coverImageUrl)
      ..writeByte(4)
      ..write(obj.summary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
