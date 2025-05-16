import 'package:flutter_test/flutter_test.dart';
import 'package:only_testosterone/services/user_services.dart'; // Замени на актуальный путь

void main() {
  group('determineTrainingLevel для мужчин', () {
    test('Новичок', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'М',
        weight: 80,
        squatMax: 80,         // 1.0 * weight
        benchPressMax: 60,    // 0.75 * weight
        deadliftMax: 85,      // 1.06 * weight
      );
      expect(level, 0);
    });

    test('Средний уровень', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'М',
        weight: 80,
        squatMax: 120,        // 1.5 * weight
        benchPressMax: 85,    // 1.06 * weight
        deadliftMax: 120,     // 1.5 * weight
      );
      expect(level, 1);
    });

    test('Продвинутый', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'М',
        weight: 80,
        squatMax: 130,        // >1.6 * weight
        benchPressMax: 90,    // >1.1 * weight
        deadliftMax: 135,     // >1.6 * weight
      );
      expect(level, 2);
    });
  });

  group('determineTrainingLevel для женщин', () {
    test('Новичок', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'Ж',
        weight: 60,
        squatMax: 40,         // 0.66 * weight
        benchPressMax: 35,    // 0.58 * weight
        deadliftMax: 50,      // 0.83 * weight
      );
      expect(level, 0);
    });

    test('Средний уровень', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'Ж',
        weight: 60,
        squatMax: 75,         // 1.25 * weight
        benchPressMax: 50,    // 0.83 * weight
        deadliftMax: 75,      // 1.25 * weight
      );
      expect(level, 1);
    });

    test('Продвинутый', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'Ж',
        weight: 60,
        squatMax: 80,         // >1.3 * weight
        benchPressMax: 60,    // >0.9 * weight
        deadliftMax: 80,      // >1.3 * weight
      );
      expect(level, 2);
    });
  });

  group('Некорректный пол', () {
    test('неизвестное значение пола возвращает 0', () {
      final level = UserServices.determineTrainingLevel(
        gender: 'X',
        weight: 70,
        squatMax: 100,
        benchPressMax: 70,
        deadliftMax: 110,
      );
      expect(level, 0);
    });
  });
}
