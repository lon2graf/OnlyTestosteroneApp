import 'package:only_testosterone/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {

  //регистрация нового подьзователя
  //сначала проверяем что логин не занят
  //потом добавляем новую запись в бд
  static Future<int?> registerUser(UserModel user) async {
    final _supClient = Supabase.instance.client;

    try {
      final existingUser = await _supClient
          .from('Users')
          .select()
          .eq('login', user.login)
          .maybeSingle();

      if (existingUser != null) {
        throw Exception('Пользователь с таким логином уже существует');
      }

      final userData = Map<String, dynamic>.from(user.toJson());
      userData.remove('id');

      final List<dynamic> insertResponse = await _supClient
          .from('Users')
          .insert(userData)
          .select(); // обязательно .select()

      if (insertResponse.isNotEmpty && insertResponse.first != null) {
        final insertedUser = insertResponse.first as Map<String, dynamic>;
        return insertedUser['id'] as int?;
      } else {
        throw Exception('Регистрация прошла, но ответ пуст');
      }
    } catch (e) {
      print("Ошибка при регистрации пользователя - $e");
      return null;
    }
  }

  //логиним пользователя
  //проверяем есть ли такой user с логином и паролем
  //если есть то true
  //если нет то false
  static Future<bool> loginUserWithModel(UserModel user) async {
    final _supClient = Supabase.instance.client;
    try{
      final response =
      await _supClient
          .from('Users')
          .select()
          .eq('login', user.login)
          .eq('password', user.password)
          .maybeSingle();

      if (response != null)
        return true;
      else
        return false;

    }
    catch(e){
      print("Ошибка при логине >> $e");
      return false;
    }
  }

  static Future<int?> loginUserWithString(String login, String password) async {
    final _supClient = Supabase.instance.client;

    try {
      final response = await _supClient
          .from('Users')
          .select()
          .eq('login', login)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        return response['id']; // Успешно — возвращаем ID
      } else {
        return null; // Неверный логин/пароль
      }
    } catch (e) {
      print('Ошибка при авторизации: $e');
      return null;
    }
  }

  static Future<bool> isLoginTaker(String login) async{
    final _supClient = Supabase.instance.client;
    try {
      final response =
      await _supClient
          .from('Users')
          .select()
          .eq('login', login)
          .maybeSingle();

      if (response != null) {
        print('стояять');
        return true;
      }
      else {
        print('проходи');
        return false;
      }
    }
    catch(e){
      print("Ошибка при логине >> $e");
      return false;
    }
  }

  static Future<UserModel?> getUserById(int id) async {
    final _supClient = Supabase.instance.client;
    try {
      final response = await _supClient
          .from('Users') // таблица в Supabase
          .select()
          .eq('id', id)
          .single(); // ожидаем один результат

      print('Response data: ${response}'); // Логируем ответ
      return UserModel.fromJson(response); // Используем response.data, а не сам response
    } catch (e) {
      print('Ошибка при получении пользователя: $e');
      return null;
    }
  }

  static int determineTrainingLevel({
    required String? gender,
    required double weight,
    required double squatMax,
    required double benchPressMax,
    required double deadliftMax,
  }) {
    if (gender == 'М') {
      bool isNovice = (squatMax >= 0.6 * weight && squatMax < 1.1 * weight) &&
          (benchPressMax >= 0.5 * weight && benchPressMax < 0.8 * weight) &&
          (deadliftMax >= 0.6 * weight && deadliftMax < 1.1 * weight);

      bool isIntermediate = (squatMax >= 1.1 * weight && squatMax < 1.6 * weight) &&
          (benchPressMax >= 0.8 * weight && benchPressMax < 1.1 * weight) &&
          (deadliftMax >= 1.1 * weight && deadliftMax < 1.6 * weight);

      bool isAdvanced = (squatMax >= 1.6 * weight) &&
          (benchPressMax >= 1.1 * weight) &&
          (deadliftMax >= 1.6 * weight);

      if (isAdvanced) return 2;
      if (isIntermediate) return 1;
      if (isNovice) return 0;
    } else if (gender == 'Ж') {
      bool isNovice = (squatMax >= 0.5 * weight && squatMax < 0.9 * weight) &&
          (benchPressMax >= 0.4 * weight && benchPressMax < 0.7 * weight) &&
          (deadliftMax >= 0.5 * weight && deadliftMax < 0.9 * weight);

      bool isIntermediate = (squatMax >= 0.9 * weight && squatMax < 1.3 * weight) &&
          (benchPressMax >= 0.7 * weight && benchPressMax < 0.9 * weight) &&
          (deadliftMax >= 0.9 * weight && deadliftMax < 1.3 * weight);

      bool isAdvanced = (squatMax >= 1.3 * weight) &&
          (benchPressMax >= 0.9 * weight) &&
          (deadliftMax >= 1.3 * weight);

      if (isAdvanced) return 2;
      if (isIntermediate) return 1;
      if (isNovice) return 0;
    }

    return 0;
  }
}

