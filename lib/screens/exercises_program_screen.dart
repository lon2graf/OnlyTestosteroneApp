import 'package:flutter/material.dart';
import 'package:only_testosterone/models/exercise_in_program_model.dart';
import 'package:only_testosterone/services/exercise_in_program_services.dart';

class WorkoutProgramDetailScreen extends StatefulWidget {
  final int programId;

  const WorkoutProgramDetailScreen({Key? key, required this.programId}) : super(key: key);

  @override
  _WorkoutProgramDetailScreenState createState() => _WorkoutProgramDetailScreenState();
}

class _WorkoutProgramDetailScreenState extends State<WorkoutProgramDetailScreen> {
  bool _isLoading = true;
  Map<int, List<ExerciseInProgramModel>> _groupedExercises = {};

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await ExerciseInProgramServices.fetchExercisesByProgramId(widget.programId);
      final Map<int, List<ExerciseInProgramModel>> grouped = {};

      for (var ex in exercises) {
        final day = int.tryParse(ex.trainingDay.toString()) ?? 0;
        grouped.putIfAbsent(day, () => []).add(ex);
      }

      setState(() {
        _groupedExercises = grouped;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки упражнений: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final subtitleStyle = TextStyle(color: Colors.black87, fontSize: 14);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Программа тренировок'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.black))
            : _groupedExercises.isEmpty
            ? Center(child: Text('Упражнения не найдены', style: subtitleStyle))
            : ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: _groupedExercises.entries.map((entry) {
            print('Группировка по дням:');
            _groupedExercises.forEach((key, value) {
              print('День $key: ${value.length} упражнений');
            });
            final trainingDay = entry.key;
            final exercises = entry.value;

            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 16),
                collapsedIconColor: Colors.black,
                iconColor: Colors.black,
                title: Text('День $trainingDay', style: titleStyle),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: exercises.map((ex) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(ex.exerciseName, style: titleStyle, textAlign: TextAlign.center),
                        SizedBox(height: 4),
                        Text(
                          '${ex.sets} x ${ex.reps}  •  ${ex.weight} кг  •  отдых ${ex.restAfterSet} сек',
                          style: subtitleStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}