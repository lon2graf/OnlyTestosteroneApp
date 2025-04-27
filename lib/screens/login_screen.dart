import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Импортируем для работы с SVG
import 'package:only_testosterone/widgets/custom_nav_button.dart';
import 'package:only_testosterone/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Отступы для всех элементов
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Логотип (уменьшаем)
              SvgPicture.asset(
                'assets/logo.svg',
                height: 200, // Уменьшаем размер логотипа
              ),
              const SizedBox(height: 20),

              // Текст "Авторизация"
              Text(
                'Авторизация',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              // Полt для ввода логина
              CustomTextField(hintText: "Логин", controller: loginController),

              const SizedBox(height: 16),

              //поле для ввода пароля
              CustomTextField(
                hintText: "Пароль",
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ), // Обеспечиваем скрытие пароля
              const SizedBox(height: 40),

              // Кнопка для авторизации
              CustomNavButton(text: 'Войти', routeName: '/home'),
              TextButton(
                onPressed: () {
                  context.push('/register');
                },
                child: Text('Нет аккаунта? Зарегайся!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Метод для создания полей ввода
  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
