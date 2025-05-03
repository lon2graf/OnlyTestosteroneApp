import 'package:flutter/material.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/screens/home_screen.dart';
import 'package:only_testosterone/supabase/supabase_config.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/screens/login_screen.dart';
import 'package:only_testosterone/screens/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:only_testosterone/services/user_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SupabaseConfig.init();

  // Получаем id пользователя из SharedPreferences
  final userId = await UserPreferences.getUserId();

  // Задаем начальную страницу в зависимости от того, авторизован ли пользователь
  final initialLocation = userId != null ? '/home' : '/login';

  final GoRouter appRouter = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegistrationScreen()),
    ],
  );

  runApp(
    MaterialApp.router(
      title: 'OnlyTest',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      routerConfig: appRouter,
    ),
  );
}

