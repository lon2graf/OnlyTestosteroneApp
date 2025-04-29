import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Импортируем для работы с SVG
import 'package:only_testosterone/services/user_services.dart';
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
              const SizedBox(height: 10),

              // Кнопка для авторизации
              //CustomNavButton(text: 'Войти', routeName: '/home'),
              //TextButton(
              //onPressed: () {
              //context.push('/register');
              //},
              //child: Text('Нет аккаунта? Зарегайся!'),
              //),

              TextButton(
                onPressed: () {
                  context.push('/register');
                },
                child: Text('Нет аккаунта? Зарегайся!'),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () async {
                  bool canLogin = await UserServices.loginUserWithString(
                    loginController.text,
                    passwordController.text,
                  );
                  if (canLogin) {
                    context.push('/home');
                  } else {
                    print('свабодин');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60), // Кнопка на всю ширину и 60 высоты
                  backgroundColor: Colors.black, // Чёрный фон кнопки
                  foregroundColor: Colors.white, // Белый цвет текста
                  textStyle: const TextStyle(
                    fontSize: 20, // Крупный текст
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Скругление краёв кнопки
                  ),
                ),
                child: const Text("Войти"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
