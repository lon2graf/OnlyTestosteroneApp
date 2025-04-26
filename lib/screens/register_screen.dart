import 'package:flutter/material.dart';
import 'package:only_testosterone/widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Регистрация")),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentStep = index;
            });
          },
          children: [
            // Этап 1: Ввод логина и пароля
            _buildStep1(),
            // Этап 2: Ввод имени и веса
            _buildStep2(),
            // Этап 3: Выбор уровня подготовки
            _buildStep3(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  // Этап 1: Ввод логина, пароля и подтверждения пароля
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(hintText: 'Логин', controller: _loginController),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Пароль',
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Подтверждение пароля',
            controller: _confirmPasswordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }

  // Этап 2: Ввод имени и веса
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Имя'),
          ),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(labelText: 'Вес'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // Этап 3: Выбор уровня подготовки
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: _selectedLevel,
            hint: Text("Выберите уровень подготовки"),
            onChanged: (value) {
              setState(() {
                _selectedLevel = value;
              });
            },
            items:
                ["Новичок", "Средний", "Продвинутый"]
                    .map(
                      (level) =>
                          DropdownMenuItem(child: Text(level), value: level),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  // Навигация по этапам
  Widget _buildNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentStep,
      onTap: (index) {
        if (index == 2 && _validateStep()) {
          // Все этапы пройдены, можно завершить регистрацию
          _completeRegistration();
        } else {
          _pageController.jumpToPage(index);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.navigate_next),
          label: "Этап 1",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigate_next),
          label: "Этап 2",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.check), label: "Завершить"),
      ],
    );
  }

  // Проверка этапов (например, если все поля заполнены)
  bool _validateStep() {
    if (_currentStep == 0) {
      return _loginController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    }
    if (_currentStep == 1) {
      return _nameController.text.isNotEmpty &&
          _weightController.text.isNotEmpty;
    }
    if (_currentStep == 2) {
      return _selectedLevel != null;
    }
    return true;
  }

  // Завершение регистрации
  void _completeRegistration() {
    // Здесь можно отправить данные на сервер или обработать их по-другому
    print("Регистрация завершена!");
  }
}
