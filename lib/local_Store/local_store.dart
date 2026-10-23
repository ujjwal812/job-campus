import 'package:shared_preferences/shared_preferences.dart';

/// Local Store helper class for managing key-value storage
/// using [SharedPreferences] in JobCampus.
class LocalStore {
  LocalStore._internal();
  static final LocalStore instance = LocalStore._internal();

  static SharedPreferences? _prefs;

  // Storage Keys
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserToken = 'user_token';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserLocation = 'user_location';
  static const String _keyUserEducation = 'user_education';
  static const String _keyUserExperience = 'user_experience';
  static const String _keyUserHeadline = 'user_headline';
  static const String _keyUserSkills = 'user_skills';
  static const String _keyIsDarkMode = 'is_dark_mode';

  /// Initialize [SharedPreferences] instance
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _sharedPrefs {
    if (_prefs == null) {
      throw Exception(
        'LocalStore not initialized. Call LocalStore.init() in main() before using.',
      );
    }
    return _prefs!;
  }

  // ===========================================================================
  // ONBOARDING
  // ===========================================================================

  Future<bool> setOnboardingCompleted(bool completed) async {
    return await _sharedPrefs.setBool(_keyOnboardingCompleted, completed);
  }

  bool isOnboardingCompleted() {
    return _sharedPrefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // ===========================================================================
  // AUTHENTICATION & LOGIN STATE
  // ===========================================================================

  Future<bool> setIsLoggedIn(bool isLoggedIn) async {
    return await _sharedPrefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _sharedPrefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<bool> setUserToken(String token) async {
    return await _sharedPrefs.setString(_keyUserToken, token);
  }

  String? getUserToken() {
    return _sharedPrefs.getString(_keyUserToken);
  }

  // ===========================================================================
  // USER PROFILE INFORMATION
  // ===========================================================================

  Future<bool> saveUserData({
    required String id,
    required String name,
    required String email,
  }) async {
    await _sharedPrefs.setString(_keyUserId, id);
    await _sharedPrefs.setString(_keyUserName, name);
    return await _sharedPrefs.setString(_keyUserEmail, email);
  }

  Future<bool> saveFullUserProfile({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String education,
    required String experience,
    required String headline,
    required List<String> skills,
  }) async {
    await _sharedPrefs.setString(_keyUserName, name);
    await _sharedPrefs.setString(_keyUserEmail, email);
    await _sharedPrefs.setString(_keyUserPhone, phone);
    await _sharedPrefs.setString(_keyUserLocation, location);
    await _sharedPrefs.setString(_keyUserEducation, education);
    await _sharedPrefs.setString(_keyUserExperience, experience);
    await _sharedPrefs.setString(_keyUserHeadline, headline);
    return await _sharedPrefs.setStringList(_keyUserSkills, skills);
  }

  String? getUserId() => _sharedPrefs.getString(_keyUserId);
  String? getUserName() => _sharedPrefs.getString(_keyUserName);
  String? getUserEmail() => _sharedPrefs.getString(_keyUserEmail);
  String? getUserPhone() => _sharedPrefs.getString(_keyUserPhone);
  String? getUserLocation() => _sharedPrefs.getString(_keyUserLocation);
  String? getUserEducation() => _sharedPrefs.getString(_keyUserEducation);
  String? getUserExperience() => _sharedPrefs.getString(_keyUserExperience);
  String? getUserHeadline() => _sharedPrefs.getString(_keyUserHeadline);
  List<String>? getUserSkills() => _sharedPrefs.getStringList(_keyUserSkills);

  // ===========================================================================
  // THEME PREFERENCES
  // ===========================================================================

  Future<bool> setIsDarkMode(bool isDark) async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.setBool(_keyIsDarkMode, isDark);
  }

  bool getIsDarkMode() {
    return _prefs?.getBool(_keyIsDarkMode) ?? true;
  }

  // ===========================================================================
  // CLEAR & LOGOUT
  // ===========================================================================

  /// Clears user session details while preserving onboarding status
  Future<bool> logout() async {
    await _sharedPrefs.remove(_keyIsLoggedIn);
    await _sharedPrefs.remove(_keyUserToken);
    await _sharedPrefs.remove(_keyUserEmail);
    await _sharedPrefs.remove(_keyUserName);
    await _sharedPrefs.remove(_keyUserId);
    await _sharedPrefs.remove(_keyUserPhone);
    await _sharedPrefs.remove(_keyUserLocation);
    await _sharedPrefs.remove(_keyUserEducation);
    await _sharedPrefs.remove(_keyUserExperience);
    await _sharedPrefs.remove(_keyUserHeadline);
    return await _sharedPrefs.remove(_keyUserSkills);
  }

  /// Clears all stored keys in local storage
  Future<bool> clearAll() async {
    return await _sharedPrefs.clear();
  }
}
