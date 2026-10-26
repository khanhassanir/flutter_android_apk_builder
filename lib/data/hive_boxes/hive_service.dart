import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/assessment_result.dart';
import '../models/daily_check_in.dart';
import '../models/exercise_log.dart';
import '../models/plan_enrollment.dart';
import '../models/user_profile.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(AppConstants.userProfileTypeId)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(AppConstants.assessmentResultTypeId)) {
      Hive.registerAdapter(AssessmentResultAdapter());
    }
    if (!Hive.isAdapterRegistered(AppConstants.exerciseLogTypeId)) {
      Hive.registerAdapter(ExerciseLogAdapter());
    }
    if (!Hive.isAdapterRegistered(AppConstants.dailyCheckInTypeId)) {
      Hive.registerAdapter(DailyCheckInAdapter());
    }
    if (!Hive.isAdapterRegistered(AppConstants.planEnrollmentTypeId)) {
      Hive.registerAdapter(PlanEnrollmentAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox<UserProfile>(AppConstants.userProfileBox),
      Hive.openBox<AssessmentResult>(AppConstants.assessmentsBox),
      Hive.openBox<ExerciseLog>(AppConstants.exerciseLogsBox),
      Hive.openBox<DailyCheckIn>(AppConstants.checkInsBox),
      Hive.openBox(AppConstants.settingsBox),
      Hive.openBox<PlanEnrollment>(AppConstants.planEnrollmentsBox),
    ]);
  }

  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(AppConstants.userProfileBox);

  static Box<AssessmentResult> get assessmentsBox =>
      Hive.box<AssessmentResult>(AppConstants.assessmentsBox);

  static Box<ExerciseLog> get exerciseLogsBox =>
      Hive.box<ExerciseLog>(AppConstants.exerciseLogsBox);

  static Box<DailyCheckIn> get checkInsBox =>
      Hive.box<DailyCheckIn>(AppConstants.checkInsBox);

  static Box get settingsBox => Hive.box(AppConstants.settingsBox);

  static Box<PlanEnrollment> get planEnrollmentsBox =>
      Hive.box<PlanEnrollment>(AppConstants.planEnrollmentsBox);

  // Settings helpers
  static bool get onboardingComplete =>
      settingsBox.get(AppConstants.kOnboardingComplete, defaultValue: false) as bool;

  static set onboardingComplete(bool value) =>
      settingsBox.put(AppConstants.kOnboardingComplete, value);

  static bool get darkMode =>
      settingsBox.get(AppConstants.kDarkMode, defaultValue: false) as bool;

  static set darkMode(bool value) =>
      settingsBox.put(AppConstants.kDarkMode, value);

  static bool get notificationsEnabled =>
      settingsBox.get(AppConstants.kNotifications, defaultValue: true) as bool;

  static set notificationsEnabled(bool value) =>
      settingsBox.put(AppConstants.kNotifications, value);

  static int get assessmentCount =>
      settingsBox.get(AppConstants.kAssessmentCount, defaultValue: 0) as int;

  static set assessmentCount(int value) =>
      settingsBox.put(AppConstants.kAssessmentCount, value);

  static int get chatCount =>
      settingsBox.get(AppConstants.kChatCount, defaultValue: 0) as int;

  static set chatCount(int value) =>
      settingsBox.put(AppConstants.kChatCount, value);

  static String? get inProgressExerciseId =>
      settingsBox.get(AppConstants.kInProgressExerciseId) as String?;

  static set inProgressExerciseId(String? value) {
    if (value == null) {
      settingsBox.delete(AppConstants.kInProgressExerciseId);
    } else {
      settingsBox.put(AppConstants.kInProgressExerciseId, value);
    }
  }

  static List<int> get inProgressCheckedSteps {
    final stored = settingsBox.get(AppConstants.kInProgressCheckedSteps);
    if (stored == null) return [];
    return (stored as List).cast<int>();
  }

  static set inProgressCheckedSteps(List<int> value) =>
      settingsBox.put(AppConstants.kInProgressCheckedSteps, value);

  // In-progress exercise metadata (for library/API exercises not in exerciseData)
  static String? get inProgressExerciseName =>
      settingsBox.get(AppConstants.kInProgressExerciseName) as String?;
  static set inProgressExerciseName(String? value) {
    if (value == null) {
      settingsBox.delete(AppConstants.kInProgressExerciseName);
    } else {
      settingsBox.put(AppConstants.kInProgressExerciseName, value);
    }
  }

  static String get inProgressExerciseImageUrl =>
      settingsBox.get(AppConstants.kInProgressExerciseImageUrl, defaultValue: '') as String;
  static set inProgressExerciseImageUrl(String value) =>
      settingsBox.put(AppConstants.kInProgressExerciseImageUrl, value);

  static List<String> get inProgressExerciseInstructions {
    final stored = settingsBox.get(AppConstants.kInProgressExerciseInstructions);
    if (stored == null) return [];
    return (stored as List).cast<String>();
  }
  static set inProgressExerciseInstructions(List<String> value) =>
      settingsBox.put(AppConstants.kInProgressExerciseInstructions, value);

  static String get inProgressExerciseBodyArea =>
      settingsBox.get(AppConstants.kInProgressExerciseBodyArea, defaultValue: '') as String;
  static set inProgressExerciseBodyArea(String value) =>
      settingsBox.put(AppConstants.kInProgressExerciseBodyArea, value);

  static String get inProgressExerciseTargetArea =>
      settingsBox.get(AppConstants.kInProgressExerciseTargetArea, defaultValue: '') as String;
  static set inProgressExerciseTargetArea(String value) =>
      settingsBox.put(AppConstants.kInProgressExerciseTargetArea, value);

  static String get inProgressExerciseDifficulty =>
      settingsBox.get(AppConstants.kInProgressExerciseDifficulty, defaultValue: 'beginner') as String;
  static set inProgressExerciseDifficulty(String value) =>
      settingsBox.put(AppConstants.kInProgressExerciseDifficulty, value);
}
