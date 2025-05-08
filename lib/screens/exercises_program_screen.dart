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
    return Scaffold(
      appBar: AppBar(title: Text('Программа тренировок')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _groupedExercises.isEmpty
          ? Center(child: Text('Упражнения не найдены'))
          : ListView(
        children: _groupedExercises.entries.map((entry) {
          final trainingDay = entry.key;
          final exercises = entry.value;
          return ExpansionTile(
            title: Text('День $trainingDay'),
            children: exercises.map((ex) {
              return ListTile(
                title: Text(ex.exerciseName),
                subtitle: Text(
                  '${ex.sets}x${ex.reps} • ${ex.weight} кг • отдых ${ex.restAfterSet} сек',
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}