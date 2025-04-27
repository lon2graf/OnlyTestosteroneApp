import 'package:only_testosterone/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {

  //регистрация нового подьзователя
  //сначала проверяем что логин не занят
  //потом добавляем новую запись в бд
  static Future<void> registerUser(UserModel user) async {
    final _supClient = Supabase.instance.client;

    try{
      final existingUser =
      await _supClient
          .from('Users')
          .select()
          .eq('login', user.login)
          .maybeSingle();

      if (existingUser != null) {
        throw Exception(('Пользователь с таким логином уже существует'));
      } else {
        final response = await _supClient.from('Users').insert(user.toJson());

        if (response.error != null) {
          throw Exception('Ошибка при регистрации : ${response.error.message}');
        }
      }
    }
    catch(e){
      print("Ошибка при регистрации пользователя - $e");
    }

  }

  //логиним пользователя
  //проверяем есть ли такой user с логином и паролем
  //если есть то true
  //если нет то false
  static Future<bool> loginUser(UserModel user) async {
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

  static Future<bool> isLoginTaker(String login) async{
    final _supClient = Supabase.instance.client;
    try{
      final response =
      await _supClient
          .from('Users')
          .select()
          .eq('login', login)
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
}
