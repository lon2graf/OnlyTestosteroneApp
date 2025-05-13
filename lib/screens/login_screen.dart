import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_testosterone/services/user_preferences.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Логотип
                        SvgPicture.asset(
                          'assets/logo.svg',
                          height: size.height * 0.25, // адаптивный размер
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Авторизация',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Логин
                        CustomTextField(
                          hintText: "Логин",
                          controller: loginController,
                        ),
                        const SizedBox(height: 16),

                        // Пароль
                        CustomTextField(
                          hintText: "Пароль",
                          controller: passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            context.push('/register');
                          },
                          child: const Text('Нет аккаунта? Зарегайся!'),
                        ),

                        const Spacer(),

                        // Кнопка Войти
                        ElevatedButton(
                          onPressed: () async {
                            int? userId =
                                await UserServices.loginUserWithString(
                                  loginController.text,
                                  passwordController.text,
                                );

                            if (userId != null) {
                              await UserPreferences.saveUserId(userId);
                              print('айдишник $userId');
                              context.go('/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Неправильный логин или пароль',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Войти"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
