abstract class AppConstants {
  // Hive box names
  static const userProfileBox = 'user_profiles';
  static const assessmentsBox = 'assessments';
  static const exerciseLogsBox = 'exercise_logs';
  static const checkInsBox = 'check_ins';
  static const settingsBox = 'settings';
  static const planEnrollmentsBox = 'plan_enrollments';

  // Hive type IDs
  static const userProfileTypeId = 0;
  static const assessmentResultTypeId = 1;
  static const exerciseLogTypeId = 2;
  static const dailyCheckInTypeId = 3;
  static const planEnrollmentTypeId = 4;

  // Settings keys
  static const kOnboardingComplete = 'onboarding_complete';
  static const kDarkMode = 'dark_mode';
  static const kNotifications = 'notifications_enabled';
  static const kAssessmentCount = 'assessment_count';
  static const kInProgressExerciseId = 'in_progress_exercise_id';
  static const kInProgressCheckedSteps = 'in_progress_checked_steps';
  static const kInProgressExerciseName = 'in_progress_exercise_name';
  static const kInProgressExerciseImageUrl = 'in_progress_exercise_image_url';
  static const kInProgressExerciseInstructions = 'in_progress_exercise_instructions';
  static const kInProgressExerciseBodyArea = 'in_progress_exercise_body_area';
  static const kInProgressExerciseTargetArea = 'in_progress_exercise_target_area';
  static const kInProgressExerciseDifficulty = 'in_progress_exercise_difficulty';
  static const kChatCount = 'chat_count';

  // UI
  static const borderRadius = 20.0;
  static const borderRadiusLarge = 28.0;
  static const borderRadiusSmall = 10.0;
  static const pagePadding = 20.0;

  // Pain types
  static const painTypes = ['sharp', 'dull', 'burning', 'stiffness', 'throbbing'];

  // Body areas
  static const bodyAreas = [
    'neck',
    'shoulders',
    'upper_back',
    'lower_back',
    'hips',
    'knees',
    'ankles',
  ];

  // Durations
  static const durations = ['today', 'few_days', 'weeks', 'months'];

  // Fitness levels
  static const fitnessLevels = ['beginner', 'intermediate', 'active'];

  // Genders
  static const genders = ['male', 'female', 'other'];

  // Play Store URL placeholder
  static const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.physioai';
}
