import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:only_testosterone/services/workout_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

// Создание моков
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockPostgrestTable extends Mock implements PostgrestTable {}
class MockPostgrestBuilder extends Mock implements PostgrestBuilder {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('addWorkoutProgram', () {
    late MockSupabaseClient mockClient;
    late MockPostgrestTable mockProgramTable;
    late MockPostgrestTable mockExerciseTable;

    const testUserId = 123;

    setUp(() {
      mockClient = MockSupabaseClient();
      mockProgramTable = MockPostgrestTable();
      mockExerciseTable = MockPostgrestTable();
    });

    test('1. Успешная загрузка JSON и добавление программы', () async {
      final json = {
        'type': 'powerlifting',
        'name': 'Test Program',
        'number_of_days_per_week': 2,
        'duration': 4,
        'exercises': [
          {
            'name': 'Bench Press',
            'training_day': 1,
            'sets': 3,
            'repetitions': 5,
            'weight': 100,
            'rest_after_set': 90,
          }
        ],
      };

      // Подменяем rootBundle.loadString
      const path = 'assets/test_program.json';
      const jsonString = '{"type":"powerlifting","name":"Test Program","number_of_days_per_week":2,"duration":4,"exercises":[{"name":"Bench Press","training_day":1,"sets":3,"repetitions":5,"weight":100,"rest_after_set":90}]}';
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) async {
        final ByteData data = ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer);
        return Future.value(data);
      });

      // Моки для insert
      when(mockClient.from('Workout_programs')).thenReturn(mockProgramTable);
      when(mockClient.from('Exercises_in_Program')).thenReturn(mockExerciseTable);

      when(mockProgramTable.insert(any)).thenReturn(mockProgramTable);
      when(mockProgramTable.select()).thenReturn(mockProgramTable);
      when(mockProgramTable.single()).thenAnswer((_) async => {'id': 99});

      when(mockExerciseTable.insert(any)).thenAnswer((_) async => null);

      // Заменить Supabase.instance.client
      Supabase.initialize(url: 'https://test.supabase.co', anonKey: 'test');
      Supabase.instance.client = mockClient;

      await WorkoutService.addWorkoutProgram(path, testUserId);
      verify(mockProgramTable.insert(any)).called(1);
      verify(mockExerciseTable.insert(any)).called(1);
    });

    test('2. Ошибка загрузки JSON — файл не существует', () async {
      const path = 'assets/invalid_path.json';

      // Симулируем отсутствие файла
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) async {
        throw FlutterError('Unable to load asset: $path');
      });

      await WorkoutService.addWorkoutProgram(path, testUserId);
      // Ожидается, что ошибка будет обработана и не вызовет падение
    });

    test('3. Программа без упражнений', () async {
      const jsonString = '{"type":"crossfit","name":"Empty Program","number_of_days_per_week":3,"duration":2,"exercises":[]}';
      const path = 'assets/empty_program.json';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) async {
        final ByteData data = ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer);
        return Future.value(data);
      });

      when(mockClient.from('Workout_programs')).thenReturn(mockProgramTable);
      when(mockClient.from('Exercises_in_Program')).thenReturn(mockExerciseTable);
      when(mockProgramTable.insert(any)).thenReturn(mockProgramTable);
      when(mockProgramTable.select()).thenReturn(mockProgramTable);
      when(mockProgramTable.single()).thenAnswer((_) async => {'id': 55});

      Supabase.instance.client = mockClient;

      await WorkoutService.addWorkoutProgram(path, testUserId);
      verifyNever(mockExerciseTable.insert(any));
    });

    test('4. Ошибка вставки программы в Supabase', () async {
      const jsonString = '{"type":"mass","name":"Broken","number_of_days_per_week":1,"duration":2,"exercises":[]}';
      const path = 'assets/error_program.json';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) async {
        final ByteData data = ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer);
        return Future.value(data);
      });

      when(mockClient.from('Workout_programs')).thenReturn(mockProgramTable);
      when(mockProgramTable.insert(any)).thenThrow(Exception('Ошибка вставки'));

      Supabase.instance.client = mockClient;

      await WorkoutService.addWorkoutProgram(path, testUserId);
      // Ошибка должна быть поймана
    });

    test('5. Ошибка при добавлении упражнения', () async {
      const jsonString = '{"type":"loss","name":"Test","number_of_days_per_week":2,"duration":2,"exercises":[{"name":"Squat","training_day":1,"sets":4,"repetitions":8,"weight":80,"rest_after_set":120}]}';
      const path = 'assets/broken_exercise.json';

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) async {
        final ByteData data = ByteData.view(Uint8List.fromList(utf8.encode(jsonString)).buffer);
        return Future.value(data);
      });

      when(mockClient.from('Workout_programs')).thenReturn(mockProgramTable);
      when(mockClient.from('Exercises_in_Program')).thenReturn(mockExerciseTable);

      when(mockProgramTable.insert(any)).thenReturn(mockProgramTable);
      when(mockProgramTable.select()).thenReturn(mockProgramTable);
      when(mockProgramTable.single()).thenAnswer((_) async => {'id': 77});

      when(mockExerciseTable.insert(any)).thenThrow(Exception('Ошибка вставки упражнения'));

      Supabase.instance.client = mockClient;

      await WorkoutService.addWorkoutProgram(path, testUserId);
    });
  });
}
