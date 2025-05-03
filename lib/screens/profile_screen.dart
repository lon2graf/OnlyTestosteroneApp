import 'package:flutter/material.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:go_router/go_router.dart';
import 'package:only_testosterone/services/user_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final userId = await UserPreferences.getUserId();
      if (userId == null) {
        throw Exception('Пользователь не найден');
      }

      final user = await UserServices.getUserById(userId);
      if (user == null) {
        throw Exception('Ошибка при получении данных пользователя');
      }

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    await UserPreferences.clearUserId();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _user == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Не удалось загрузить профиль.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Имя: ${_user!.name}', style: _textStyle),
          Text('Логин: ${_user!.login}', style: _textStyle),
          Text('Вес: ${_user!.weight} кг', style: _textStyle),
          Text('Пол: ${_user!.gender}', style: _textStyle),
          Text('Жим лёжа (1ПМ): ${_user!.benchPress} кг', style: _textStyle),
          Text('Присед (1ПМ): ${_user!.squat} кг', style: _textStyle),
          Text('Тяга (1ПМ): ${_user!.deadLift} кг', style: _textStyle),
          Text('Уровень подготовки: ${_user!.levelOfTraining}', style: _textStyle),
          Text('Калораж: ${_user!.dailyCalories} ккал', style: _textStyle),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Выйти'),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _textStyle => const TextStyle(fontSize: 18, height: 1.6);
}
