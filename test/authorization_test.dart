import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:only_testosterone/services/user_services.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockFilterBuilder extends Mock
    implements PostgrestFilterBuilder<Map<String, dynamic>?> {}

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

  test('1. Успешный логин возвращает id', () async {
    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'user')).thenReturn(mockFilter);
    when(mockFilter.eq('password', 'pass')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => {'id': 5});

    final result = await UserServices.loginUserWithString('user', 'pass');
    expect(result, 5);
  });

  test('2. Неверный логин/пароль возвращает null', () async {
    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'user')).thenReturn(mockFilter);
    when(mockFilter.eq('password', 'wrong')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    final result = await UserServices.loginUserWithString('user', 'wrong');
    expect(result, isNull);
  });

  test('3. Исключение при запросе возвращает null', () async {
    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq(any, any)).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenThrow(Exception('DB failure'));

    final result = await UserServices.loginUserWithString('crash', 'error');
    expect(result, isNull);
  });

  test('4. Пустой логин и пароль возвращает null', () async {
    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', '')).thenReturn(mockFilter);
    when(mockFilter.eq('password', '')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => null);

    final result = await UserServices.loginUserWithString('', '');
    expect(result, isNull);
  });

  test('5. Ответ без поля id возвращает null', () async {
    when(mockQuery.select()).thenReturn(mockFilter);
    when(mockFilter.eq('login', 'user')).thenReturn(mockFilter);
    when(mockFilter.eq('password', 'pass')).thenReturn(mockFilter);
    when(mockFilter.maybeSingle()).thenAnswer((_) async => {'name': 'NoIdUser'});

    final result = await UserServices.loginUserWithString('user', 'pass');
    expect(result, isNull);
  });
}