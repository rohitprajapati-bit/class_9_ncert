// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ncert.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NcertAdapter extends TypeAdapter<Ncert> {
  @override
  final int typeId = 0;

  @override
  Ncert read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ncert(
      id: fields[0] as int?,
      stg: fields[1] as String?,
      name: fields[2] as String?,
      language: (fields[3] as List?)?.cast<Language>(),
    );
  }

  @override
  void write(BinaryWriter writer, Ncert obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stg)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NcertAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
