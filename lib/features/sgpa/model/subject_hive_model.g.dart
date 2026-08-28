// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectHiveModelAdapter extends TypeAdapter<SubjectHiveModel> {
  @override
  final int typeId = 0;

  @override
  SubjectHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectHiveModel(
      subjectName: fields[0] as String,
      credits: fields[1] as double,
      gradePoint: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.subjectName)
      ..writeByte(1)
      ..write(obj.credits)
      ..writeByte(2)
      ..write(obj.gradePoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
