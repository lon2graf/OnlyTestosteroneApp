import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/services/user_services.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockFilterBuilder extends Mock
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

void main() {
  late MockSupabaseClient mockClient;
  late MockQueryBuilder mockQuery;
  late MockFilterBuilder mockFilter;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockQuery = MockQueryBuilder();
    mockFilter = MockFilterBuilder();

    UserServices.setClientForTest(mockClient);
    when(mockClient.from('Users')).thenReturn(mockQuery);
  });

  test('1. Успешная регистрация возвращает id', () async {
    final user = UserModel(id: null, login: 'newuser', name: 'Mike', password: '1234');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'newuser')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenAnswer((_) async => PostgrestResponse(
      data: [{'id': 42}],
      error: null,
      status: 201,
      count: null,
    ));

    final id = await UserServices.registerUser(user);
    expect(id, equals(42));
  });

  test('2. Регистрация с уже занятым логином возвращает null', () async {
    final user = UserModel(id: null, login: 'taken', name: 'Anna', password: 'qwerty');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'taken')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => {'id': 1});

    final id = await UserServices.registerUser(user);
    expect(id, isNull);
  });

  test('3. Ошибка при вставке пользователя — возвращает null', () async {
    final user = UserModel(id: null, login: 'erroruser', name: 'Jack', password: 'fail');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'erroruser')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenThrow(Exception('DB error'));

    final id = await UserServices.registerUser(user);
    expect(id, isNull);
  });

  test('4. Пустой ответ после вставки — возвращает null', () async {
    final user = UserModel(id: null, login: 'empty', name: 'Sara', password: 'pass');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'empty')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenAnswer((_) async => PostgrestResponse(
      data: [],
      error: null,
      status: 201,
      count: null,
    ));

    final id = await UserServices.registerUser(user);
    expect(id, isNull);
  });

  test('5. У пользователя id = null', () async {
    final user = UserModel(id: null, login: 'nonid', name: 'Bob', password: 'xyz');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'nonid')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenAnswer((_) async => PostgrestResponse(
      data: [{'id': 77}],
      error: null,
      status: 201,
      count: null,
    ));

    final id = await UserServices.registerUser(user);
    expect(id, equals(77));
  });

  test('6. Вставка возвращает null вместо списка — ошибка', () async {
    final user = UserModel(id: null, login: 'nullinsert', name: 'Dima', password: 'pass');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'nullinsert')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenAnswer((_) async => PostgrestResponse(
      data: null,
      error: null,
      status: 201,
      count: null,
    ));

    final id = await UserServices.registerUser(user);
    expect(id, isNull);
  });

  test('7. Логин пустой — возвращает null', () async {
    final user = UserModel(id: null, login: '', name: 'Ghost', password: '123');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', '')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenAnswer((_) async => PostgrestResponse(
      data: [{'id': 99}],
      error: null,
      status: 201,
      count: null,
    ));

    final id = await UserServices.registerUser(user);
    expect(id, equals(99));
  });

  test('8. Имя пользователя null — регистрация проходит', () async {
    final user = UserModel(id: null, login: 'noname', name: '', password: '0000');

    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'noname')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    when(mockQuery.insert(any)).thenReturn(mockQuery);
    when(mockQuery.select()).thenReturn(mockQuery);
    when(mockQuery.execute()).thenAnswer((_) async => PostgrestResponse(
      data: [{'id': 11}],
      error: null,
      status: 201,
      count: null,
    ));

    final id = await UserServices.registerUser(user);
    expect(id, equals(11));
  });
}
