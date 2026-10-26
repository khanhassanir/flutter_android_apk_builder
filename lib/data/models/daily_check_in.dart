import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

class DailyCheckIn extends HiveObject {
  DateTime date;
  int painLevel;
  String exerciseFeel;   // easy | moderate | hard | skipped | none
  List<String> symptoms; // no_change | less_pain | more_stiff | swelling | tingling | worse
  String aiInsight;
  String sleepQuality;   // poorly | okay | well  (only when plan active)
  String energyLevel;    // low | normal | good   (only when plan active)
  String stressLevel;    // calm | moderate | stressed
  String moodToday;      // good | okay | low
  String activityLevel;  // resting | light | active

  DailyCheckIn({
    required this.date,
    required this.painLevel,
    this.exerciseFeel = 'none',
    List<String>? symptoms,
    this.aiInsight = '',
    this.sleepQuality = '',
    this.energyLevel = '',
    this.stressLevel = '',
    this.moodToday = '',
    this.activityLevel = '',
  }) : symptoms = symptoms ?? [];
}

class DailyCheckInAdapter extends TypeAdapter<DailyCheckIn> {
  @override
  final int typeId = AppConstants.dailyCheckInTypeId;

  @override
  DailyCheckIn read(BinaryReader reader) {
    final n = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < n; i++) reader.readByte(): reader.read(),
    };
    return DailyCheckIn(
      date: fields[0] as DateTime,
      painLevel: fields[1] as int,
      exerciseFeel: fields[2] as String? ?? 'none',
      symptoms: (fields[3] as List?)?.cast<String>() ?? [],
      aiInsight: fields[4] as String? ?? '',
      sleepQuality: fields[5] as String? ?? '',
      energyLevel: fields[6] as String? ?? '',
      stressLevel: fields[7] as String? ?? '',
      moodToday: fields[8] as String? ?? '',
      activityLevel: fields[9] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, DailyCheckIn obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.painLevel)
      ..writeByte(2)
      ..write(obj.exerciseFeel)
      ..writeByte(3)
      ..write(obj.symptoms)
      ..writeByte(4)
      ..write(obj.aiInsight)
      ..writeByte(5)
      ..write(obj.sleepQuality)
      ..writeByte(6)
      ..write(obj.energyLevel)
      ..writeByte(7)
      ..write(obj.stressLevel)
      ..writeByte(8)
      ..write(obj.moodToday)
      ..writeByte(9)
      ..write(obj.activityLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyCheckInAdapter && typeId == other.typeId;
}
