class WorkoutProgramModel{
  final int? id;
  final int userId;
  final String? type;
  final String? name;
  final int daysPerWeek;
  final int duration;

  WorkoutProgramModel({
    this.id,
    required this.userId,
    this.type,
    this.name,
    required this.daysPerWeek,
    required this.duration,
  });

  // Конструктор для создания объекта из JSON
  factory WorkoutProgramModel.fromJson(Map<String, dynamic> json) {
    return WorkoutProgramModel(
      id: json['id'],  // id будет получен из ответа сервера
      userId: json['user_id'],
      type: json['type'],
      name: json['name'],
      daysPerWeek: json['days_per_week'],
      duration: json['duration'],
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'type': type,
      'name': name,
      'days_per_week': daysPerWeek,
      'duration': duration,
    };
  }
}
