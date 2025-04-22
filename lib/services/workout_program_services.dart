import 'package:only_testosterone/models/exercise_in_program_model.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:only_testosterone/models/workout_program_model.dart';

class WorkoutProgramServices{

  //добваление новой программы тренировок в бд
  static Future<void> registerWorkoutProgram (WorkoutProgramModel prog, ExerciseInProgramModel exerices) async{
    final _supClient = Supabase.instance.client;
    try{
      final response = await _supClient.from('Workout_programs').insert(prog.toJson());
      final programId = response['id'];

      if (response != null){
        print('Регистрация успешни');
      }


    }
    catch(e){

    }


  }

}