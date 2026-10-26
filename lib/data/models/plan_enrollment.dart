import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

class PlanEnrollment extends HiveObject {
  String planId;
  DateTime startDate;
  List<int> completedDays;
  bool isActive;

  PlanEnrollment({
    required this.planId,
    required this.startDate,
    required this.completedDays,
    this.isActive = true,
  });
}

class PlanEnrollmentAdapter extends TypeAdapter<PlanEnrollment> {
  @override
  final int typeId = AppConstants.planEnrollmentTypeId;

  @override
  PlanEnrollment read(BinaryReader reader) {
    final n = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < n; i++) reader.readByte(): reader.read(),
    };
    return PlanEnrollment(
      planId: fields[0] as String,
      startDate: fields[1] as DateTime,
      completedDays: List<int>.from(fields[2] as List),
      isActive: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlanEnrollment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.planId)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.completedDays)
      ..writeByte(3)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanEnrollmentAdapter && typeId == other.typeId;
}
