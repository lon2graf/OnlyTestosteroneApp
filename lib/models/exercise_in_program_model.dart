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
      programId: json['Program_Id'],
      exerciseName: json['Exercise_name'],
      trainingDay: json['Training_day'],
      sets: json['Sets'],
      reps: json['Reps'],
      weight: json['Weight']?.toString() ?? '',
      restAfterSet: json['Rest_after_set'],
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'Program_Id': programId,
      'Exercise_name': exerciseName,
      'training_day': trainingDay,
      'Sets': sets,
      'Reps': reps,
      'Weight': weight,
      'Rest_after_set': restAfterSet,
    };
  }
}