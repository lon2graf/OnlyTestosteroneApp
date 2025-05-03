import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static const String _userIdKey = 'user_id';

  //Установить Id
  static Future<void> saveUserId(int id) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
  }

  //Получить Id
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// Удаляет ID
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}