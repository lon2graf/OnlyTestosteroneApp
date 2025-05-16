import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:only_testosterone/services/user_services.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockUpdateBuilder extends Mock
    implements PostgrestFilterBuilder<dynamic> {}

void main() {
  late MockSupabaseClient mockClient;
  late MockQueryBuilder mockQuery;
  late MockUpdateBuilder mockUpdate;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockQuery = MockQueryBuilder();
    mockUpdate = MockUpdateBuilder();

    UserServices.setClientForTest(mockClient);
    when(mockClient.from('Users')).thenReturn(mockQuery);
  });

  test('1. Успешное обновление возвращает true', () async {
    when(mockQuery.update(any)).thenReturn(mockUpdate);
    when(mockUpdate.eq('id', 1)).thenAnswer((_) async => [{}]);

    final result = await UserServices.updateOneRepMaxes(
      userId: 1,
      benchPress: 100.0,
      squat: 120.0,
      deadLift: 140.0,
    );

    expect(result, isTrue);
  });

  test('2. Обновление с null значениями возвращает true', () async {
    when(mockQuery.update(any)).thenReturn(mockUpdate);
    when(mockUpdate.eq('id', 2)).thenAnswer((_) async => [{}]);

    final result = await UserServices.updateOneRepMaxes(
      userId: 2,
      benchPress: null,
      squat: null,
      deadLift: null,
    );

    expect(result, isTrue);
  });

  test('3. Исключение при обновлении возвращает false', () async {
    when(mockQuery.update(any)).thenReturn(mockUpdate);
    when(mockUpdate.eq('id', 3)).thenThrow(Exception('Update failed'));

    final result = await UserServices.updateOneRepMaxes(
      userId: 3,
      benchPress: 90.0,
      squat: 110.0,
      deadLift: 130.0,
    );

    expect(result, isFalse);
  });

  test('4. Только одно значение (benchPress) передано — возвращает true', () async {
    when(mockQuery.update(any)).thenReturn(mockUpdate);
    when(mockUpdate.eq('id', 4)).thenAnswer((_) async => [{}]);

    final result = await UserServices.updateOneRepMaxes(
      userId: 4,
      benchPress: 95.0,
    );

    expect(result, isTrue);
  });

  test('5. Некорректный userId (отрицательный) — возвращает true (все равно)', () async {
    when(mockQuery.update(any)).thenReturn(mockUpdate);
    when(mockUpdate.eq('id', -1)).thenAnswer((_) async => [{}]);

    final result = await UserServices.updateOneRepMaxes(
      userId: -1,
      squat: 105.0,
    );

    expect(result, isTrue);
  });
}