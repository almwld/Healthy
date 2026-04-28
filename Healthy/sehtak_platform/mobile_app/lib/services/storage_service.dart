import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _onboardingKey = 'onboarding_seen';

  StorageService._(this._prefs);

  static Future<StorageService> init() async {
    if (_instance != null) return _instance!;
    final prefs = await SharedPreferences.getInstance();
    _instance = StorageService._(prefs);
    return _instance!;
  }

  static StorageService get instance => _instance!;

  Future<void> saveToken(String token) async => await _prefs.setString(_tokenKey, token);
  String? getToken() => _prefs.getString(_tokenKey);
  Future<void> clearToken() async => await _prefs.remove(_tokenKey);

  Future<void> saveUserData(String userJson) async => await _prefs.setString(_userKey, userJson);
  String? getUserData() => _prefs.getString(_userKey);
  Future<void> clearUserData() async => await _prefs.remove(_userKey);

  Future<void> setOnboardingSeen(bool seen) async => await _prefs.setBool(_onboardingKey, seen);
  bool isOnboardingSeen() => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> clearAll() async => await _prefs.clear();
}
