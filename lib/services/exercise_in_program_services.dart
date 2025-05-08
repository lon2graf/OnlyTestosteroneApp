import 'package:only_testosterone/models/exercise_in_program_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseInProgramServices{

  static Future<void> registerExerciseInProgram(ExerciseInProgramModel exercise,int workoutProgramId) async{
    final _supClient = Supabase.instance.client;

    exercise.programId = workoutProgramId;
    
    try{
      final response = await _supClient.from('Exercises_in_Program').insert(exercise.toJson());
      if (response){
        print('$response[id] успешно добавлен');
      }
    }

    catch(e){
      print('Ошибка при добавлении упражнения >> $e');
    }

    //final response = await _supClient.from().insert()

  }

  static Future<List<ExerciseInProgramModel>> fetchExercisesByProgramId(int programId) async {
    final _supClient = Supabase.instance.client;
    final response = await _supClient
        .from('Exercises_in_Program')
        .select()
        .eq('Program_Id', programId);

    return (response as List)
        .map((e) => ExerciseInProgramModel.fromJson(e))
        .toList();
  }

}