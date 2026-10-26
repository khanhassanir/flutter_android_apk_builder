import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

class AssessmentResult extends HiveObject {
  String id;
  DateTime date;
  String area;
  String painType;
  int intensity;
  String duration;
  String diagnosis;
  int confidence;
  List<String> exerciseIds;
  // 'ai' = Given by AI engine | 'app_assessment' = App Assessment flow
  String source;

  AssessmentResult({
    required this.id,
    required this.date,
    required this.area,
    required this.painType,
    required this.intensity,
    required this.duration,
    required this.diagnosis,
    required this.confidence,
    required this.exerciseIds,
    this.source = 'ai',
  });
}

class AssessmentResultAdapter extends TypeAdapter<AssessmentResult> {
  @override
  final int typeId = AppConstants.assessmentResultTypeId;

  @override
  AssessmentResult read(BinaryReader reader) {
    final n = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < n; i++) reader.readByte(): reader.read(),
    };
    return AssessmentResult(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      area: fields[2] as String,
      painType: fields[3] as String,
      intensity: fields[4] as int,
      duration: fields[5] as String,
      diagnosis: fields[6] as String,
      confidence: fields[7] as int,
      exerciseIds: (fields[8] as List).cast<String>(),
      // field 9 is new — old records won't have it, so default to 'ai'
      source: fields[9] as String? ?? 'ai',
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentResult obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.area)
      ..writeByte(3)
      ..write(obj.painType)
      ..writeByte(4)
      ..write(obj.intensity)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.diagnosis)
      ..writeByte(7)
      ..write(obj.confidence)
      ..writeByte(8)
      ..write(obj.exerciseIds)
      ..writeByte(9)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentResultAdapter && typeId == other.typeId;
}
