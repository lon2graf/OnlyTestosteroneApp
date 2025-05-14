import 'package:flutter/material.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _showEditOneRMDialog() {
    final benchController = TextEditingController(
      text: _user?.benchPress?.toString() ?? '',
    );
    final squatController = TextEditingController(
      text: _user?.squat?.toString() ?? '',
    );
    final deadLiftController = TextEditingController(
      text: _user?.deadLift?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Изменить результаты 1ПМ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: benchController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Жим лёжа (кг)'),
                ),
                TextField(
                  controller: squatController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Присед (кг)'),
                ),
                TextField(
                  controller: deadLiftController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Становая (кг)'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final userId = await UserPreferences.getUserId();
                  if (userId == null) return;

                  final bench = double.tryParse(benchController.text);
                  final squat = double.tryParse(squatController.text);
                  final deadlift = double.tryParse(deadLiftController.text);

                  final success = await UserServices.updateOneRepMaxes(
                    userId: userId,
                    benchPress: bench,
                    squat: squat,
                    deadLift: deadlift,
                  );

                  if (success) {
                    // 💡 Пересчитываем уровень подготовки
                    final newLevel = UserServices.determineTrainingLevel(
                      gender: _user!.gender,
                      weight: _user!.weight!,
                      squatMax: squat ?? 0,
                      benchPressMax: bench ?? 0,
                      deadliftMax: deadlift ?? 0,
                    );

                    // 💾 Обновляем уровень в базе
                    await UserServices.updateTrainingLevel(
                      userId: userId,
                      level: newLevel,
                    );

                    // Закрываем диалог и обновляем UI
                    Navigator.pop(context);
                    _loadUser();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ошибка при обновлении 1ПМ'),
                      ),
                    );
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
    );
  }

  Future<void> _loadUser() async {
    try {
      final userId = await UserPreferences.getUserId();
      if (userId != null) {
        final user = await UserServices.getUserById(userId);
        if (user != null) {
          setState(() {
            _user = user;
            _isLoading = false;
          });
        } else {
          throw Exception("Пользователь не найден");
        }
      } else {
        throw Exception("ID пользователя не найден");
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при получении пользователя';
        _isLoading = false;
      });
    }
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildOneRMCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.black),
        title: const Text("Результаты 1ПМ"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Жим лёжа: ${_user!.benchPress?.toString() ?? '—'} кг"),
            Text("Присед: ${_user!.squat?.toString() ?? '—'} кг"),
            Text("Становая: ${_user!.deadLift?.toString() ?? '—'} кг"),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    await UserPreferences.clearUserId();
    if (!mounted) return;
    context.push('/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, bottom: 60),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth < 600 ? double.infinity : 600,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Text(
                  "Добро пожаловать!",
                  style: TextStyle(
                    fontSize: screenWidth < 350 ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildInfoCard(Icons.person, "Имя", _user!.name ?? '—'),
              _buildInfoCard(
                Icons.account_circle,
                "Логин",
                _user!.login ?? '—',
              ),
              _buildInfoCard(
                Icons.monitor_weight,
                "Вес",
                "${_user!.weight ?? '—'} кг",
              ),
              _buildInfoCard(
                Icons.wc,
                "Пол",
                _user!.gender == 'М'
                    ? 'Мужской'
                    : _user!.gender == 'Ж'
                    ? 'Женский'
                    : '—',
              ),
              _buildOneRMCard(),
              _buildInfoCard(
                Icons.military_tech,
                "Уровень подготовки",
                _user!.levelOfTraining?.toString() ?? '—',
              ),
              _buildInfoCard(
                Icons.local_fire_department,
                "Калории в день",
                "${_user!.dailyCalories?.toStringAsFixed(0) ?? '—'} ккал",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _showEditOneRMDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text("Изменить рекорды"),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _logout,
                  child: const Text("Выйти"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
