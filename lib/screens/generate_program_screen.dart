import 'package:flutter/material.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/services/workout_program_services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  bool _isLoading = false;

  UserModel? _user;

  final List<String> _programTypes = [
    'Пауэрлифтинг',
    'Бодибилдинг',
    'Кроссфит',
  ];

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

  Future<void> _generateProgram() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите тип программы')),
      );
      return;
    }

    if (_user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Пользователь не загружен')));
      return;
    }

    final gender = _user?.gender?.toLowerCase();
    final level = _user?.levelOfTraining;

    if (gender == null || level == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Данные пользователя неполные')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String path = WorkoutProgramServices.generateWorkoutProgramPath(
        gender: gender,
        level: level,
        weeks: _duration,
        daysPerWeek: _daysPerWeek,
      );

      print('Путь к файлу программы: $path');

      if (_user!.id != null) {
        await WorkoutProgramServices.addWorkoutProgram(path, _user!.id!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Программа успешно сгенерирована!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: не удалось получить ID пользователя'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка при генерации: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryTextStyle = TextStyle(color: Colors.black87, fontSize: 16);
    final headingStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Логотип
              Center(
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  height: 128, // Уменьшаем размер логотипа
                ),
              ),
              SizedBox(height: 24),

              // Заголовок
              Center(child: Text('Генерация программы тренировок', style: headingStyle)),

              SizedBox(height: 32),

              // Тип программы
              Text('Тип программы', style: primaryTextStyle),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
                style: TextStyle(color: Colors.black),
                items:
                    _programTypes
                        .map(
                          (type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),

              SizedBox(height: 24),

              // Длительность
              Text('Длительность: $_duration недель', style: primaryTextStyle),
              Slider(
                min: 2,
                max: 6,
                divisions: 2,
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                value: _duration.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _duration = value.round();
                  });
                },
              ),

              // Частота
              Text(
                'Тренировок в неделю: $_daysPerWeek',
                style: primaryTextStyle,
              ),
              Slider(
                min: 2,
                max: 4,
                divisions: 2,
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                value: _daysPerWeek.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _daysPerWeek = value.round();
                  });
                },
              ),

              SizedBox(height: 32),

              // Кнопка генерации
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _generateProgram,
                  icon: Icon(Icons.fitness_center, color: Colors.white),
                  label:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Сгенерировать",
                            style: TextStyle(fontSize: 16),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
