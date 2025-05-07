import 'package:flutter/material.dart';
import 'package:only_testosterone/models/workout_program_model.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:only_testosterone/services/workout_program_services.dart';

class UserProgramsScreen extends StatefulWidget {
  @override
  _UserProgramsScreenState createState() => _UserProgramsScreenState();
}

class _UserProgramsScreenState extends State<UserProgramsScreen> {
  List<WorkoutProgramModel> _programs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    final int? userId = await UserPreferences.getUserId();
    if (userId != null) {
      final programs = await WorkoutProgramServices.getProgramsByUserId(userId);
      setState(() {
        _programs = programs;
        _isLoading = false;
      });
    } else {
      // Ошибка: пользователь не найден
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось получить пользователя')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои программы')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _programs.isEmpty
              ? Center(child: Text('Нет сохранённых программ'))
              : ListView.builder(
                itemCount: _programs.length,
                itemBuilder: (context, index) {
                  final program = _programs[index];

                  // Расшифровка типа
                  String typeLabel;
                  switch (program.type) {
                    case 'p':
                      typeLabel = 'Пауэрлифтинг';
                      break;
                    case 'пауэрлифтинг':
                      typeLabel = 'Пауэрлифтинг';
                      break;
                    case 'b':
                      typeLabel = 'Бодибилдинг';
                      break;
                    case 'c':
                      typeLabel = 'Кроссфит';
                      break;
                    default:
                      typeLabel = 'Неизвестно';
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        typeLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${program.duration} нед., ${program.daysPerWeek} трен./нед.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                      onTap: () {
                        // TODO: переход к подробному экрану программы
                      },
                    ),
                  );
                },
              ),
    );
  }
}
