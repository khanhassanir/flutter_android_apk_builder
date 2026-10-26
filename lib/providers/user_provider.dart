import 'package:flutter/foundation.dart';
import '../data/hive_boxes/hive_service.dart';
import '../data/models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isDarkMode = false;

  UserProfile? get profile => _profile;
  bool get isDarkMode => _isDarkMode;
  bool get isOnboardingComplete => HiveService.onboardingComplete && _profile != null;

  void init() {
    _loadProfile();
    _isDarkMode = HiveService.darkMode;
  }

  void _loadProfile() {
    final box = HiveService.userProfileBox;
    if (box.isNotEmpty) {
      _profile = box.getAt(0);
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final box = HiveService.userProfileBox;
    if (box.isEmpty) {
      await box.add(profile);
    } else {
      await box.putAt(0, profile);
    }
    _profile = profile;
    notifyListeners();
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    await saveProfile(profile);
    HiveService.onboardingComplete = true;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    HiveService.darkMode = _isDarkMode;
    notifyListeners();
  }
}
