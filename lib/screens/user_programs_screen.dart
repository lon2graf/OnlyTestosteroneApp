import 'package:flutter/material.dart';
import 'package:only_testosterone/models/workout_program_model.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:only_testosterone/services/workout_program_services.dart';
import 'package:only_testosterone/screens/exercises_program_screen.dart';

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

  String _getTypeLabel(String? type) {
    switch (type?.toLowerCase()) {
      case 'p':
      case 'пауэрлифтинг':
        return 'Пауэрлифтинг';
      case 'b':
        return 'Бодибилдинг';
      case 'c':
        return 'Кроссфит';
      default:
        return 'Неизвестно';
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final subtitleStyle = TextStyle(color: Colors.black54, fontSize: 14);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.black))
                : _programs.isEmpty
                ? Center(
                  child: Text(
                    'Нет сохранённых программ',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: _programs.length,
                  itemBuilder: (context, index) {
                    final program = _programs[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          _getTypeLabel(program.type),
                          style: titleStyle,
                        ),
                        subtitle: Text(
                          '${program.duration} недель, ${program.daysPerWeek} раз в неделю',
                          style: subtitleStyle,
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WorkoutProgramDetailScreen(
                                    programId: program.id!,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
