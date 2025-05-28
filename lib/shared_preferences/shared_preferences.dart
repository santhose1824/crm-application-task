import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _roleKey = 'role';
  static const String _uidKey = 'uid';

  /// Save UID
  Future<void> saveUserId(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  /// Save Role
  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  /// Get UID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  /// Get Role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Clear All (e.g. on Logout)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
