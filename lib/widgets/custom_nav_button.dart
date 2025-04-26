//кастомная кнопка
//предназначена для навигации между экранами

import 'package:flutter/material.dart';
import 'package:only_testosterone/main.dart';
import 'package:go_router/go_router.dart';

class CustomNavButton extends StatelessWidget {
  final String text;
  final String routeName;
  //final VoidCallback? onPressed;

  const CustomNavButton({
    super.key,
    required this.text,
    required this.routeName,
    //this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          try {
            context.push(routeName);
          } catch (e) {
            print('Ошибка перехода: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
