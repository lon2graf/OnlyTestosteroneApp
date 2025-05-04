import 'package:flutter/material.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/services/workout_program_services.dart';

class TrainingProgramGeneratorScreen extends StatefulWidget {
  @override
  _TrainingProgramGeneratorScreenState createState() =>
      _TrainingProgramGeneratorScreenState();
}

class _TrainingProgramGeneratorScreenState
    extends State<TrainingProgramGeneratorScreen> {
  String? _selectedType;
  int _duration = 2;
  int _daysPerWeek = 3;

  UserModel? _user;

  final List<String> _programTypes = ['Пауэрлифтинг', 'Бодибилдинг', 'Кроссфит'];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final int? userId = await UserPreferences.getUserId();
    if (userId != null) {
      final user = await UserServices.getUserById(userId);
      setState(() {
        _user = user;
      });
    }
  }

  void _generateProgram() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите тип программы')),
      );
      return;
    }

    if (_user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь не загружен')),
      );
      return;
    }

    final gender = _user?.gender;

    final level = _user?.levelOfTraining;

    if (gender == null || level == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Данные пользователя неполные')),
      );
      return;
    }
    String path = WorkoutProgramServices.generateWorkoutProgramPath(
      gender: gender,
      level: level,
      weeks: _duration,
      daysPerWeek: _daysPerWeek,
    );

    print('Путь к файлу программы: $path');

    if (_user!.id != null) {
      WorkoutProgramServices.addWorkoutProgram(path, _user!.id!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: не удалось получить ID пользователя')),
      );
    }
    // здесь ты можешь вызвать метод загрузки программы из JSON и добавления в БД
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Генерация программы'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Тип программы',
                border: OutlineInputBorder(),
              ),
              items: _programTypes
                  .map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Длительность: $_duration недель"),
                Slider(
                  min: 2,
                  max: 6,
                  divisions: 2,
                  label: _duration.toString(),
                  value: _duration.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _duration = value.round();
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Тренировок в неделю: $_daysPerWeek"),
                Slider(
                  min: 2,
                  max: 4,
                  divisions: 2,
                  label: _daysPerWeek.toString(),
                  value: _daysPerWeek.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _daysPerWeek = value.round();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.fitness_center),
              label: Text("Сгенерировать программу"),
              onPressed: _generateProgram,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}