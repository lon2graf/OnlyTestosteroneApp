class UserModel {
  final int? id;
  final String login;
  final String name;
  final String password;
  final double? weight;
  final String? gender; // может быть null
  final double? benchPress; // может быть null
  final double? deadLift; // может быть null
  final double? squat; // может быть null
  final int? levelOfTraining; // может быть null
  final double? dailyCalories; // может быть null

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

  Map<String, dynamic> toJson(){
    final map =
      {
        'id':id,
        'login': login,
        'name' : name,
        'password' : password,
        'weight' : weight,
        'gender' : gender,
        'Rm_benchPress' : benchPress,
        'Rm_deadLift' : deadLift,
        'Rm_squat' : squat,
        'levelOfTraining' : levelOfTraining,
        'daily_calories' : dailyCalories
      };
    return map;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toDouble();
      if (value is double) return value;
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
