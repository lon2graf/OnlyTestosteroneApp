import 'package:flutter/material.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:only_testosterone/supabase/supabase_config.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/screens/main_screen.dart';
import 'package:only_testosterone/screens/login_screen.dart';
import 'package:only_testosterone/screens/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  SupabaseConfig.init();
  await dotenv.load(fileName: ".env");
  UserModel user = new UserModel(
    name: 'Рес',
    login: 'propanButan',
    password: '123',
  );



  runApp(
    MaterialApp(
      title: 'OnlyTest',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        // '/knowledge_base': (context) => KnowledgeBaseScreen(),
      },
    ),
  );
}
