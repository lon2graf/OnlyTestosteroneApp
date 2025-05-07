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
      userId: json['User_id'],
      type: json['Type'],
      name: json['Name'],
      daysPerWeek: json['Days_Per_Week'],
      duration: json['Duration'],
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'User_id': userId,
      'Type': type,
      'Name': name,
      'Days_Per_Week': daysPerWeek,
      'Duration': duration,
    };
  }
}
