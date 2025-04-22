import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Импортируем для работы с SVG

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

              // Поля для ввода логина и пароля
              _buildTextField('Логин'),
              const SizedBox(height: 16),
              _buildTextField('Пароль', obscureText: true), // Обеспечиваем скрытие пароля
              const SizedBox(height: 40),

              // Кнопка для авторизации
              _buildButton(context, 'Войти', '/home'), // Заменить на нужный путь
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  // Метод для создания кнопки
  Widget _buildButton(BuildContext context, String text, String routeName) {
    return SizedBox(
      width: 220,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}