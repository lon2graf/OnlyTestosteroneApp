import 'package:flutter_test/flutter_test.dart';
import 'package:only_testosterone/models/workout_program_model.dart';

void main() {
  group('WorkoutProgramModel', () {
    test('Создание с обязательными полями', () {
      final model = WorkoutProgramModel(
        userId: 1,
        daysPerWeek: 3,
        duration: 6,
      );
      expect(model.userId, 1);
      expect(model.daysPerWeek, 3);
      expect(model.duration, 6);
    });

    test('Сериализация в JSON без необязательных полей', () {
      final model = WorkoutProgramModel(
        userId: 2,
        daysPerWeek: 4,
        duration: 8,
      );
      final json = model.toJson();
      expect(json['User_id'], 2);
      expect(json['Type'], isNull);
      expect(json['Name'], isNull);
    });

    test('Сериализация в JSON с полями type и name', () {
      final model = WorkoutProgramModel(
        userId: 5,
        type: 'powerlifting',
        name: 'Beginner Strength',
        daysPerWeek: 2,
        duration: 4,
      );
      final json = model.toJson();
      expect(json['Type'], 'powerlifting');
      expect(json['Name'], 'Beginner Strength');
    });

    test('Десериализация из полного JSON', () {
      final json = {
        'id': 10,
        'User_id': 3,
        'Type': 'bodybuilding',
        'Name': 'Mass Gain',
        'Days_Per_Week': 4,
        'Duration': 6,
      };

      final model = WorkoutProgramModel.fromJson(json);
      expect(model.id, 10);
      expect(model.userId, 3);
      expect(model.type, 'bodybuilding');
      expect(model.name, 'Mass Gain');
    });

    test('Десериализация работает при отсутствии id', () {
      final json = {
        'User_id': 4,
        'Type': 'crossfit',
        'Name': 'WOD Blast',
        'Days_Per_Week': 3,
        'Duration': 5,
      };

      final model = WorkoutProgramModel.fromJson(json);
      expect(model.id, isNull);
      expect(model.type, 'crossfit');
    });

    test('toJson корректно отображает поля', () {
      final model = WorkoutProgramModel(
        userId: 6,
        type: 'fitness',
        name: 'Fat Loss',
        daysPerWeek: 3,
        duration: 6,
      );
      final json = model.toJson();
      expect(json.keys.length, 5);
      expect(json['Days_Per_Week'], 3);
    });

    test('fromJson корректно обрабатывает нулевые значения', () {
      final json = {
        'id': null,
        'User_id': 1,
        'Type': null,
        'Name': null,
        'Days_Per_Week': 3,
        'Duration': 8,
      };

      final model = WorkoutProgramModel.fromJson(json);
      expect(model.id, isNull);
      expect(model.type, isNull);
      expect(model.name, isNull);
    });

    test('Проверка на корректный тип id', () {
      final json = {
        'id': 15,
        'User_id': 7,
        'Days_Per_Week': 2,
        'Duration': 2,
      };
      final model = WorkoutProgramModel.fromJson(json);
      expect(model.id, isA<int>());
    });

    test('Сериализация и десериализация эквивалентны', () {
      final model = WorkoutProgramModel(
        userId: 11,
        type: 'strength',
        name: 'Elite Routine',
        daysPerWeek: 4,
        duration: 10,
      );

      final json = model.toJson();
      final fromJsonModel = WorkoutProgramModel.fromJson({
        ...json,
        'id': 99,
      });

      expect(fromJsonModel.userId, model.userId);
      expect(fromJsonModel.name, model.name);
      expect(fromJsonModel.type, model.type);
    });

    test('Проверка граничных значений', () {
      final model = WorkoutProgramModel(
        userId: 1,
        daysPerWeek: 1,
        duration: 1,
      );
      expect(model.daysPerWeek, greaterThanOrEqualTo(1));
      expect(model.duration, greaterThanOrEqualTo(1));
    });
  });
}
