import 'package:flutter_test/flutter_test.dart';
import 'package:only_testosterone/models/user_model.dart'; // замените на ваш путь

void main() {
  group('UserModel', () {
    test('Создание объекта с обязательными полями', () {
      final user = UserModel(
        login: 'testuser',
        name: 'Test User',
        password: 'password123',
      );
      expect(user.login, 'testuser');
      expect(user.name, 'Test User');
      expect(user.password, 'password123');
    });

    test('Сериализация в JSON', () {
      final user = UserModel(
        id: 1,
        login: 'user1',
        name: 'User One',
        password: 'pass',
        weight: 75.0,
        gender: 'М',
        benchPress: 100,
        deadLift: 150,
        squat: 120,
        levelOfTraining: 1,
        dailyCalories: 2800,
      );

      final json = user.toJson();
      expect(json['id'], 1);
      expect(json['login'], 'user1');
      expect(json['Rm_benchPress'], 100);
    });

    test('Десериализация из JSON', () {
      final json = {
        'id': 5,
        'login': 'user5',
        'name': 'User Five',
        'password': 'p@ss',
        'weight': '82.5',
        'gender': 'Ж',
        'Rm_benchPress': '95.0',
        'Rm_deadLift': 140,
        'Rm_squat': null,
        'levelOfTraining': 2,
        'daily_calories': 2500,
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 5);
      expect(user.weight, 82.5);
      expect(user.benchPress, 95.0);
      expect(user.squat, isNull);
    });

    test('toJson возвращает корректные ключи', () {
      final user = UserModel(
        login: 'login',
        name: 'Имя',
        password: '1234',
      );
      final json = user.toJson();
      expect(json.containsKey('login'), true);
      expect(json.containsKey('Rm_benchPress'), true);
      expect(json.containsKey('gender'), true);
    });

    test('Десериализация работает при int значениях double полей', () {
      final json = {
        'login': 'intuser',
        'name': 'Int Name',
        'password': 'intpass',
        'weight': 70,
        'Rm_benchPress': 90,
        'Rm_deadLift': 130,
        'Rm_squat': 110,
        'daily_calories': 2700,
      };

      final user = UserModel.fromJson(json);
      expect(user.weight, 70.0);
      expect(user.benchPress, 90.0);
    });

    test('toJson не выбрасывает ошибку при null значениях', () {
      final user = UserModel(
        login: 'nulluser',
        name: 'Null Name',
        password: 'nullpass',
      );

      final json = user.toJson();
      expect(json['weight'], isNull);
      expect(json['Rm_deadLift'], isNull);
    });

    test('fromJson безопасно обрабатывает пустые строки как null', () {
      final json = {
        'login': 'empty',
        'name': 'Empty Name',
        'password': '',
        'weight': '',
        'Rm_benchPress': '',
      };

      final user = UserModel.fromJson(json);
      expect(user.weight, isNull);
      expect(user.benchPress, isNull);
    });


    test('Работа с уровнем подготовки', () {
      final user = UserModel(
        login: 'lvl',
        name: 'Trainer',
        password: '123',
        levelOfTraining: 1,
      );
      expect(user.levelOfTraining, 1);
    });
  });
}