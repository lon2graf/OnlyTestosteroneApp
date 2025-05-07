import 'package:flutter/services.dart' show rootBundle;
import 'package:only_testosterone/models/exercise_in_program_model.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:only_testosterone/models/workout_program_model.dart';
import 'dart:convert';

class WorkoutProgramServices {
  //добваление новой программы тренировок в бд
  static Future<void> addWorkoutProgram(String jsonPath, int userId) async {
    try {
      final _supClient = Supabase.instance.client;
      // 1. Загрузить JSON-файл
      final jsonString = await rootBundle.loadString(jsonPath);
      final jsonData = json.decode(jsonString);

      // 2. Сформировать WorkoutProgramModel
      final programResponse =
          await _supClient
              .from('Workout_programs')
              .insert({
                'User_id': userId,
                'Type': jsonData['type'],
                'Name': jsonData['name'],
                'Days_Per_Week': jsonData['number_of_days_per_week'],
                'Duration': jsonData['duration'],
              })
              .select()
              .single();

      final int programId = programResponse['id'];

      // 3. Добавить упражнения
      final List exercises = jsonData['exercises'];
      for (final ex in exercises) {
        await _supClient.from('Exercises_in_Program').insert({
          'Program_Id': programId,
          'Exercise_name': ex['name'],
          'Training_day': ex['training_day'].toString(),
          'Sets': ex['sets'].toString(),
          'Reps': ex['repetitions'].toString(),
          'Weight': ex['weight'],
          'Rest_after_set': ex['rest_after_set'].toString(),
        });
      }

      print('Программа успешно добавлена в базу данных.');
    } catch (e) {
      print('Ошибка при добавлении программы: $e');
    }
  }

  static String generateWorkoutProgramPath({
    required String gender, // Пол: "м" или "ж"
    required int level, // Уровень: 0, 1, или 2
    required int weeks, // Количество недель: 2, 4, или 6
    required int daysPerWeek, // Количество тренировок в неделю: 2, 3, или 4
  }) {
    gender = gender.toLowerCase();
    // Формируем путь к файлу в зависимости от входных данных
    String path = 'assets/programs/p/';

    // Добавляем пол
    path += '$gender/';

    // Добавляем уровень
    path += '$level/';

    // Добавляем количество недель
    path += '$weeks недели/';

    // Добавляем количество тренировок в неделю
    path += '$daysPerWeek/TrainingProgram.json';

    return path;
  }

  static Future<List<WorkoutProgramModel>> getProgramsByUserId(
    int userId,
  ) async {
    final _supClient = Supabase.instance.client;

    try {
      final response = await _supClient
          .from('Workout_programs')
          .select()
          .eq('User_id', userId);

      if (response != null && response is List) {
        return response
            .map((json) => WorkoutProgramModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Ошибка при получении данных - $e');
      return [];
    }
  }
}
