import 'package:only_testosterone/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  static SupabaseClient _supClient = Supabase.instance.client;

  //метод для теста
  static void setClientForTest(SupabaseClient client) {
    _supClient = client;
  }
  /// Регистрирует нового пользователя
  /// 1. Проверяет, занят ли логин
  /// 2. Если логин свободен, добавляет нового пользователя в БД
  static Future<int?> registerUser(UserModel user) async {
    try {
      // Проверка, занят ли логин
      final existingUser =
          await _supClient
              .from('Users')
              .select()
              .eq('login', user.login)
              .maybeSingle();

      if (existingUser != null) {
        throw Exception('Пользователь с таким логином уже существует');
      }

      // Преобразуем объект в JSON и удаляем id (т.к. он автогенерируется)
      final userData = Map<String, dynamic>.from(user.toJson());
      userData.remove('id');

      // Вставка пользователя в таблицу Users
      final List<dynamic> insertResponse =
          await _supClient
              .from('Users')
              .insert(userData)
              .select(); // возвращает вставленную запись

      if (insertResponse.isNotEmpty) {
        final insertedUser = insertResponse.first as Map<String, dynamic>;
        return insertedUser['id'] as int?;
      } else {
        throw Exception('Регистрация прошла, но ответ пуст');
      }
    } catch (e) {
      print("Ошибка при регистрации пользователя: $e");
      return null;
    }
  }

  static Future<bool> updateTrainingLevel({
    required int userId,
    required int level,
  }) async {
    try {
      final response = await _supClient
          .from('Users')
          .update({'levelOfTraining': level})
          .eq('id', userId);

      return response.error == null;
    } catch (e) {
      print("Ошибка при обновлении уровня подготовки: $e");
      return false;
    }
  }

  /// Авторизация пользователя по модели UserModel
  /// Возвращает true, если пользователь найден, иначе false
  static Future<bool> loginUserWithModel(UserModel user) async {
    try {
      final response =
          await _supClient
              .from('Users')
              .select()
              .eq('login', user.login)
              .eq('password', user.password)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print("Ошибка при логине: $e");
      return false;
    }
  }

  /// Авторизация пользователя по строковым данным
  /// Возвращает ID пользователя, если вход успешен, иначе null
  static Future<int?> loginUserWithString(String login, String password) async {
    try {
      final response =
          await _supClient
              .from('Users')
              .select()
              .eq('login', login)
              .eq('password', password)
              .maybeSingle();

      return response?['id'];
    } catch (e) {
      print('Ошибка при авторизации: $e');
      return null;
    }
  }

  /// Проверка, занят ли логин
  /// Возвращает true, если логин уже используется
  static Future<bool> isLoginTaker(String login) async {
    try {
      final response =
          await _supClient
              .from('Users')
              .select()
              .eq('login', login)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print("Ошибка при проверке логина: $e");
      return false;
    }
  }

  /// Получение пользователя по ID
  /// Возвращает объект UserModel или null
  static Future<UserModel?> getUserById(int id) async {
    try {
      final response =
          await _supClient.from('Users').select().eq('id', id).single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Ошибка при получении пользователя: $e');
      return null;
    }
  }

  /// Определение уровня подготовки пользователя
  /// 0 — новичок, 1 — средний, 2 — продвинутый
  static int determineTrainingLevel({
    required String? gender,
    required double weight,
    required double squatMax,
    required double benchPressMax,
    required double deadliftMax,
  }) {
    if (gender == 'М') {
      final isNovice =
          (squatMax >= 0.6 * weight && squatMax < 1.1 * weight) &&
          (benchPressMax >= 0.5 * weight && benchPressMax < 0.8 * weight) &&
          (deadliftMax >= 0.6 * weight && deadliftMax < 1.1 * weight);

      final isIntermediate =
          (squatMax >= 1.1 * weight && squatMax < 1.6 * weight) &&
          (benchPressMax >= 0.8 * weight && benchPressMax < 1.1 * weight) &&
          (deadliftMax >= 1.1 * weight && deadliftMax < 1.6 * weight);

      final isAdvanced =
          squatMax >= 1.6 * weight &&
          benchPressMax >= 1.1 * weight &&
          deadliftMax >= 1.6 * weight;

      if (isAdvanced) return 2;
      if (isIntermediate) return 1;
      if (isNovice) return 0;
    }

    if (gender == 'Ж') {
      final isNovice =
          (squatMax >= 0.5 * weight && squatMax < 0.9 * weight) &&
          (benchPressMax >= 0.4 * weight && benchPressMax < 0.7 * weight) &&
          (deadliftMax >= 0.5 * weight && deadliftMax < 0.9 * weight);

      final isIntermediate =
          (squatMax >= 0.9 * weight && squatMax < 1.3 * weight) &&
          (benchPressMax >= 0.7 * weight && benchPressMax < 0.9 * weight) &&
          (deadliftMax >= 0.9 * weight && deadliftMax < 1.3 * weight);

      final isAdvanced =
          squatMax >= 1.3 * weight &&
          benchPressMax >= 0.9 * weight &&
          deadliftMax >= 1.3 * weight;

      if (isAdvanced) return 2;
      if (isIntermediate) return 1;
      if (isNovice) return 0;
    }

    return 0; // По умолчанию — новичок
  }

  static Future<bool> updateOneRepMaxes({
    required int userId,
    double? benchPress,
    double? squat,
    double? deadLift,
  }) async {
    try {
      final responce = await _supClient
          .from('Users')
          .update({
            'Rm_benchPress': benchPress,
            'Rm_squat': squat,
            'Rm_deadLift': deadLift,
          })
          .eq('id', userId);

      return true; // если дошло до сюда — успех
    } catch (e) {
      print("Ошибка при обновлении 1ПМ: $e");
      return false;
    }
  }
}
