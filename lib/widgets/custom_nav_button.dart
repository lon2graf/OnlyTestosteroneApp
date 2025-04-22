//кастомная кнопка
//предназначена для навигации между экранами

import 'package:flutter/material.dart';

class CustomNavButton extends StatelessWidget {
  final String text;
  final String routeName;

  const CustomNavButton({
    super.key,
    required this.text,
    required this.routeName,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          try {
            Navigator.pushNamed(context, routeName);
          } catch (e) {
            print('Ошибка перехода: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}



