import 'package:flutter/material.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/supabase/supabase_config.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/screens/main_screen.dart';
import 'package:only_testosterone/screens/login_screen.dart';
import 'package:only_testosterone/screens/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SupabaseConfig.init();

  final GoRouter appRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => MainScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegistrationScreen()),
    ],
  );

  runApp(
    MaterialApp.router(
      title: 'OnlyTest',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      routerConfig: appRouter, // передаем сюда appRouter
    ),
  );


}
