class ExerciseInProgramModel{
  final int? id; // ID может быть null при создании нового объекта
  int programId;
  final String exerciseName;
  final String trainingDay;
  final String sets;
  final String reps;
  final String weight;
  final String restAfterSet;

  ExerciseInProgramModel({
    this.id,
    required this.programId,
    required this.exerciseName,
    required this.trainingDay,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restAfterSet,
  });

  // Метод для создания объекта из JSON
  factory ExerciseInProgramModel.fromJson(Map<String, dynamic> json) {
    return ExerciseInProgramModel(
      id: json['id'],
      programId: json['program_id'],
      exerciseName: json['exercise_name'],
      trainingDay: json['training_day'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'],
      restAfterSet: json['rest_after_set'],
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'program_id': programId,
      'exercise_name': exerciseName,
      'training_day': trainingDay,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'rest_after_set': restAfterSet,
    };
  }
}