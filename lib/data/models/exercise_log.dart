import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

class ExerciseLog extends HiveObject {
  String exerciseId;
  DateTime completedAt;
  int setsDone;

  ExerciseLog({
    required this.exerciseId,
    required this.completedAt,
    required this.setsDone,
  });
}

class ExerciseLogAdapter extends TypeAdapter<ExerciseLog> {
  @override
  final int typeId = AppConstants.exerciseLogTypeId;

  @override
  ExerciseLog read(BinaryReader reader) {
    final n = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < n; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLog(
      exerciseId: fields[0] as String,
      completedAt: fields[1] as DateTime,
      setsDone: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.setsDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLogAdapter && typeId == other.typeId;
}
