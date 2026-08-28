// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamHiveModelAdapter extends TypeAdapter<ExamHiveModel> {
  @override
  final int typeId = 1;

  @override
  ExamHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamHiveModel(
      subjectName: fields[0] as String,
      examDate: fields[1] as DateTime,
      note: fields[2] as String,
      id: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.subjectName)
      ..writeByte(1)
      ..write(obj.examDate)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
