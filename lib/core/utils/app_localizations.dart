// Simple localization class — English only for initial release.
// Replace with generated intl code for multi-language support.
abstract class S {
  // App
  static const appName = 'PhysioAI';
  static const tagline = 'Your Personal Physio, Powered by AI';

  // Onboarding
  static const onboarding1Title = 'Your Personal Physio';
  static const onboarding1Subtitle =
      'AI-powered physiotherapy guidance at your fingertips, completely offline.';
  static const onboarding2Title = 'Tell Us About You';
  static const onboarding2Subtitle =
      'We\'ll personalize your experience based on your profile.';
  static const onboarding3Title = 'Where Does It Hurt?';
  static const onboarding3Subtitle =
      'Tap the areas on the body map where you commonly experience pain.';
  static const getStarted = 'Get Started';
  static const next = 'Next';
  static const back = 'Back';
  static const skip = 'Skip';

  // Greeting
  static const goodMorning = 'Good morning';
  static const goodAfternoon = 'Good afternoon';
  static const goodEvening = 'Good evening';
  static const letsCheckIn = "Let's check in.";

  // Home
  static const howAreYouFeeling = 'How are you feeling today?';
  static const startAssessment = 'Start AI Assessment';
  static const dailyCheckIn = 'Daily Check-in';
  static const painLevel = 'Pain Level';
  static const recommendedExercise = 'Recommended Exercise';
  static const noRecommendation =
      'Complete an assessment to get your personalized exercise plan.';
  static const tapToBegin = 'Tap to begin';

  // Bottom Nav
  static const navHome = 'Home';
  static const navAssess = 'Assess';
  static const navExercises = 'Exercises';
  static const navProgress = 'Progress';

  // Assessment
  static const aiAnalysis = 'AI Analysis';
  static const selectPainArea = 'Where does it hurt?';
  static const selectPainAreaSub = 'Tap the area on the body map';
  static const selectPainType = 'How does it feel?';
  static const selectPainTypeSub = 'Select the type of pain you experience';
  static const intensityQuestion = 'How intense is the pain?';
  static const durationQuestion = 'How long have you had this?';
  static const analyzingTitle = 'AI Analyzing...';
  static const analyzingSubtitle =
      'Running pattern analysis on your symptoms';
  static const resultsTitle = 'Assessment Results';
  static const confidenceMatch = 'confidence match';
  static const recommendedExercises = 'Recommended Exercises';
  static const disclaimer =
      'For wellness purposes only. Not a substitute for professional medical advice. Please consult a qualified healthcare professional for diagnosis and treatment.';
  static const saveAndContinue = 'Save & View Exercises';
  static const newAssessment = 'New Assessment';

  // Pain Types
  static const sharp = 'Sharp';
  static const dull = 'Dull';
  static const burning = 'Burning';
  static const stiffness = 'Stiffness';
  static const throbbing = 'Throbbing';

  // Durations
  static const today = 'Today';
  static const fewDays = 'Few Days';
  static const weeks = 'Weeks';
  static const months = 'Months+';

  // Exercises
  static const exerciseLibrary = 'Exercise Library';
  static const searchExercises = 'Search exercises...';
  static const markAsDone = 'Mark as Done';
  static const markedDone = 'Done!';
  static const sets = 'Sets';
  static const reps = 'Reps';
  static const hold = 'Hold';
  static const instructions = 'Instructions';
  static const beginner = 'Beginner';
  static const intermediate = 'Intermediate';
  static const advanced = 'Advanced';
  static const allAreas = 'All Areas';

  // Body Areas
  static const neck = 'Neck';
  static const shoulders = 'Shoulders';
  static const upperBack = 'Upper Back';
  static const lowerBack = 'Lower Back';
  static const hips = 'Hips';
  static const knees = 'Knees';
  static const ankles = 'Ankles';

  // Progress
  static const progressTitle = 'Progress';
  static const weeklyPainTrend = 'Weekly Pain Trend';
  static const streakCounter = 'Day Streak';
  static const totalExercises = 'Exercises Done';
  static const painHistory = 'Most Assessed Areas';
  static const aiInsights = 'AI Insights';
  static const noDataYet =
      'No data yet.\nComplete a check-in or assessment to see your progress.';
  static const days = 'days';
  static const consistent = 'consistent';

  // Settings
  static const settingsTitle = 'Settings';
  static const editProfile = 'Edit Profile';
  static const notifications = 'Daily Reminders';
  static const darkMode = 'Dark Mode';
  static const rateApp = 'Rate the App';
  static const about = 'About PhysioAI';
  static const disclaimerTitle = 'Medical Disclaimer';
  static const version = 'Version 1.0.0';
  static const aboutText =
      'PhysioAI is an offline physiotherapy assistant designed to help you manage pain and improve mobility through guided exercises. Always consult a healthcare professional for medical advice.';

  // Posture
  static const postureCheck = 'Posture Check';
  static const posturePremium = 'Premium Feature';
  static const postureUnlock = 'Unlock posture analysis';
  static const postureTagline = 'Real-time AI posture feedback using your camera.';
  static const cameraPermissionRequired = 'Camera permission is required for posture analysis.';

  // Profile Form
  static const fullName = 'Full Name';
  static const age = 'Age';
  static const gender = 'Gender';
  static const male = 'Male';
  static const female = 'Female';
  static const other = 'Other';
  static const fitnessLevel = 'Fitness Level';
  static const beginnerLevel = 'Beginner';
  static const intermediateLevel = 'Intermediate';
  static const activeLevel = 'Active';

  // General
  static const done = 'Done';
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const loading = 'Loading...';
  static const retry = 'Retry';
  static const frontView = 'Front';
  static const backView = 'Back';
  static const selectArea = 'Select area';
  static const tapOnBodyMap = 'Tap on the body map to select an area';

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return goodMorning;
    if (hour < 17) return goodAfternoon;
    return goodEvening;
  }

  static String areaLabel(String area) {
    const map = {
      'neck': neck,
      'shoulders': shoulders,
      'upper_back': upperBack,
      'lower_back': lowerBack,
      'hips': hips,
      'knees': knees,
      'ankles': ankles,
    };
    return map[area] ?? area;
  }

  static String painTypeLabel(String type) {
    const map = {
      'sharp': sharp,
      'dull': dull,
      'burning': burning,
      'stiffness': stiffness,
      'throbbing': throbbing,
    };
    return map[type] ?? type;
  }

  static String durationLabel(String d) {
    const map = {
      'today': today,
      'few_days': fewDays,
      'weeks': weeks,
      'months': months,
    };
    return map[d] ?? d;
  }
}
