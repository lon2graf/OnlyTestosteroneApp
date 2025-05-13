/// Модель пользователя, отражающая структуру таблицы 'Users' в Supabase
class UserModel {
  final int? id; // ID пользователя (nullable, т.к. может не быть при регистрации)
  final String login; // Логин (уникальный)
  final String name; // Имя пользователя
  final String password; // Пароль
  final double? weight; // Вес пользователя
  final String? gender; // Пол: 'М' или 'Ж'
  final double? benchPress; // 1ПМ в жиме лёжа
  final double? deadLift; // 1ПМ в тяге
  final double? squat; // 1ПМ в приседе
  final int? levelOfTraining; // Уровень подготовки: 0 — новичок, 1 — средний, 2 — продвинутый
  final double? dailyCalories; // Рассчитанная суточная калорийность

  UserModel({
    this.id,
    required this.name,
    required this.login,
    required this.password,
    this.weight,
    this.gender,
    this.benchPress,
    this.deadLift,
    this.squat,
    this.levelOfTraining,
    this.dailyCalories,
  });

  /// Преобразование модели в JSON для отправки в Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'name': name,
      'password': password,
      'weight': weight,
      'gender': gender,
      'Rm_benchPress': benchPress,
      'Rm_deadLift': deadLift,
      'Rm_squat': squat,
      'levelOfTraining': levelOfTraining,
      'daily_calories': dailyCalories,
    };
  }

  /// Фабричный метод для создания модели из JSON, полученного от Supabase
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Приватный метод для безопасного приведения типов к double
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return UserModel(
      id: json['id'],
      login: json['login'],
      name: json['name'],
      password: json['password'],
      weight: _toDouble(json['weight']),
      gender: json['gender'],
      benchPress: _toDouble(json['Rm_benchPress']),
      deadLift: _toDouble(json['Rm_deadLift']),
      squat: _toDouble(json['Rm_squat']),
      levelOfTraining: json['levelOfTraining'],
      dailyCalories: _toDouble(json['daily_calories']),
    );
  }
}
