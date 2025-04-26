import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_testosterone/widgets/custom_nav_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          // Используем Center для полной центровки содержимого
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Центрируем элементы по вертикали
            crossAxisAlignment:
                CrossAxisAlignment.center, // Центрируем элементы по горизонтали
            children: [
              // SVG логотип
              SvgPicture.asset('assets/logo.svg', height: 300),
              const SizedBox(height: 40),

              // Кнопки
              CustomNavButton(text: 'Регистрация', routeName: '/register'),
              const SizedBox(height: 16),
              CustomNavButton(text: 'Авторизация', routeName: '/login'),
              const SizedBox(height: 16),
              //CustomNavButton(text: '', routeName: '/register'),
            ],
          ),
        ),
      ),
    );
  }

}
