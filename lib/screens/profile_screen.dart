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
      if (userId == null) throw Exception('Пользователь не найден');
      final user = await UserServices.getUserById(userId);
      if (user == null) throw Exception('Ошибка при получении пользователя');

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
    if (_isLoading) return const Center(child: CircularProgressIndicator());

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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildCard('Имя', _user!.name),
          _buildCard('Логин', _user!.login),
          _buildCard('Вес', '${_user!.weight} кг'),
          _buildCard('Пол', _user!.gender ?? '-'),
          _buildCard('Жим лёжа', '${_user!.benchPress} кг'),
          _buildCard('Присед', '${_user!.squat} кг'),
          _buildCard('Становая тяга', '${_user!.deadLift} кг'),
          _buildCard('Уровень подготовки', _user!.levelOfTraining.toString()),
          _buildCard('Калораж', '${_user!.dailyCalories} ккал'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Выйти'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}