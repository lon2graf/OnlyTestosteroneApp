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

  static int determineTrainingLevel({
    required String? gender,
    required double weight,
    required double squatMax,
    required double benchPressMax,
    required double deadliftMax,
  }) {
    if (gender == 'М') {
      if ((squatMax >= 0.5 * weight && squatMax <= 1 * weight) ||
          (benchPressMax >= 0.4 * weight && benchPressMax <= 0.7 * weight) ||
          (deadliftMax >= 0.5 * weight && deadliftMax <= 1 * weight)) {
        return 0; // Новичок
      } else if ((squatMax >= 1 * weight && squatMax <= 1.5 * weight) ||
          (benchPressMax >= 0.7 * weight && benchPressMax <= 1 * weight) ||
          (deadliftMax >= 1 * weight && deadliftMax <= 1.5 * weight)) {
        return 1; // Средний
      } else if ((squatMax > 1.5 * weight) ||
          (benchPressMax >= 1 * weight) ||
          (deadliftMax >= 1.5 * weight)) {
        return 2; // Продвинутый
      }
    } else if (gender == 'Ж') {
      if ((squatMax >= 0.4 * weight && squatMax <= 0.8 * weight) ||
          (benchPressMax >= 0.3 * weight && benchPressMax <= 0.6 * weight) ||
          (deadliftMax >= 0.4 * weight && deadliftMax <= 0.8 * weight)) {
        return 0; // Новичок
      } else if ((squatMax >= 0.8 * weight && squatMax <= 1.2 * weight) ||
          (benchPressMax >= 0.6 * weight && benchPressMax <= 0.8 * weight) ||
          (deadliftMax >= 0.8 * weight && deadliftMax <= 1.2 * weight)) {
        return 1; // Средний
      } else if ((squatMax > 1.2 * weight) ||
          (benchPressMax >= 0.8 * weight) ||
          (deadliftMax >= 1.2 * weight)) {
        return 2; // Продвинутый
      }
    }

    return 0; // По умолчанию считаем новичком
  }
}

