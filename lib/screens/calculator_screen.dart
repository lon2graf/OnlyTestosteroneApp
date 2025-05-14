import 'package:flutter/material.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:only_testosterone/services/user_services.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double _activityLevel = 1.2;
  double? _calories;
  double? _protein;
  double? _fats;
  double? _carbs;

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userId = await UserPreferences.getUserId();
    if (userId != null) {
      final user = await UserServices.getUserById(userId);
      setState(() {
        _user = user;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _calculate() {
    final weight = _user?.weight ?? 0;
    final gender = _user?.gender;
    final height = double.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);

    if (weight <= 0 || gender == null) {
      _showError("Не удалось загрузить данные пользователя.");
      return;
    }

    if (age == null || age < 0 || age > 110) {
      _showError("Введите возраст от 0 до 110.");
      return;
    }

    if (height == null || height < 100 || height > 230) {
      _showError("Введите рост от 100 до 230 см.");
      return;
    }

    double bmr = gender == 'М'
        ? 10 * weight + 6.25 * height - 5 * age + 5
        : 10 * weight + 6.25 * height - 5 * age - 161;

    final tdee = bmr * _activityLevel;

    setState(() {
      _calories = tdee;
      _protein = weight * 2.0;
      _fats = weight * 1.0;
      _carbs = (tdee - (_protein! * 4 + _fats! * 9)) / 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Калькулятор КБЖУ",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.cake),
                labelText: "Возраст",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.height),
                labelText: "Рост (см)",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.run_circle),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<double>(
                    isExpanded: true,
                    value: _activityLevel,
                    items: const [
                      DropdownMenuItem(value: 1.2, child: Text("Минимальная")),
                      DropdownMenuItem(value: 1.375, child: Text("Низкая (1-2 тренировки)")),
                      DropdownMenuItem(value: 1.55, child: Text("Средняя (3-4 тренировки)")),
                      DropdownMenuItem(value: 1.725, child: Text("Высокая (5+ тренировок)")),
                      DropdownMenuItem(value: 1.9, child: Text("Очень высокая (2х в день)")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _activityLevel = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calculate),
                  SizedBox(width: 8),
                  Text("Рассчитать КБЖУ"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (_calories != null) ...[
              _buildResult("Калории", _calories!, Icons.local_fire_department),
              _buildResult("Белки (г)", _protein!, Icons.fitness_center),
              _buildResult("Жиры (г)", _fats!, Icons.egg),
              _buildResult("Углеводы (г)", _carbs!, Icons.rice_bowl),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildResult(String label, double value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text(
            "$label: ${value.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
