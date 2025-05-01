import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/widgets/custom_text_field.dart'; // не забудь поправить путь!

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

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
  final TextEditingController _squatController = TextEditingController();
  final TextEditingController _benchController = TextEditingController();
  final TextEditingController _deadliftController = TextEditingController();
  int _calculatedLevel = 0;
  String _selectedGender = 'М';

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация")),
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset('assets/logo.svg', height: 200),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // отключаем свайпы вручную
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: 'Логин',
            controller: _loginController,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Пароль',
            controller: _passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Подтверждение пароля',
            controller: _confirmPasswordController,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: 'Имя',
            controller: _nameController,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Вес (кг)',
            controller: _weightController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text(
            'Пол',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // Выбор пола
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('М'),
                selected: _selectedGender == 'М',
                onSelected: (selected) {
                  setState(() {
                    print(_selectedGender);
                    _selectedGender = 'М';
                  });
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Ж'),
                selected: _selectedGender == 'Ж',
                onSelected: (selected) {
                  setState(() {
                    print(_selectedGender);
                    _selectedGender = 'Ж';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: '1ПМ в приседе (кг)',
            controller: _squatController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateTrainingLevel(),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: '1ПМ в жиме лёжа (кг)',
            controller: _benchController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateTrainingLevel(),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: '1ПМ в становой тяге (кг)',
            controller: _deadliftController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateTrainingLevel(),
          ),
          const SizedBox(height: 24),
          Text(
            _calculatedLevel != null
                ? "Ваш уровень подготовки: ${_getLevelText(_calculatedLevel!)}"
                : "Введите данные, чтобы определить уровень подготовки",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                setState(() {
                  _currentStep--;
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(140, 45), // Умеренный размер кнопки
                backgroundColor: Colors.black, // Чёрный фон
                foregroundColor: Colors.white, // Белый текст
                textStyle: const TextStyle(
                  fontSize: 16, // Чуть меньше размер текста
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Скругление углов
                ),
              ),
              child: const Text("Назад"),
            ),
          ElevatedButton(
            onPressed: () async {
              bool isValidStep = await _validateStep();
              if (isValidStep) {
                if (_currentStep < 2) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  _completeRegistration();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(140, 45), // Умеренный размер кнопки
              backgroundColor: Colors.black, // Чёрный фон
              foregroundColor: Colors.white, // Белый текст
              textStyle: const TextStyle(
                fontSize: 16, // Чуть меньше размер текста
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Скругление углов
              ),
            ),
            child: Text(_currentStep < 2 ? "Далее" : "Завершить"),
          ),
        ],
      ),
    );
  }

  Future<bool> _validateStep() async {
    if (_currentStep == 0) {
      if (_loginController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        _showError("Пожалуйста, заполните все поля.");
        return false;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError("Пароли не совпадают.");
        return false;
      }
      if (await UserServices.isLoginTaker(_loginController.text)) {
        _showError("Такой логин уже занят");
        return false;
      }
    } else if (_currentStep == 1) {
      if (_nameController.text.isEmpty || _weightController.text.isEmpty) {
        _showError("Пожалуйста, введите имя и вес.");
        return false;
      }
      if (double.tryParse(_weightController.text) == null) {
        _showError("Вес должен быть числом.");
        return false;
      }
      if (_selectedGender == null) {
        _showError("Пожалуйста, выберите пол.");
        return false;
      }
    } else if (_currentStep == 2) {
      if (_calculatedLevel == null) {
        _showError("Пожалуйста, заполните все поля.");
        return false;
      }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _getLevelText(int level) {
    switch (level) {
      case 0:
        return 'Начальный уровень подготовки';
      case 1:
        return 'Средний уровень подготовки';
      case 2:
        return 'Продвинутый уровень подготовки';
      default:
        return 'Неизвестный уровень';
    }
  }
  void _updateTrainingLevel() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final squatMax = double.tryParse(_squatController.text) ?? 0;
    final benchPressMax = double.tryParse(_benchController.text) ?? 0;
    final deadliftMax = double.tryParse(_deadliftController.text) ?? 0;

    final level = UserServices.determineTrainingLevel(
      gender: _selectedGender,
      weight: weight,
      squatMax: squatMax,
      benchPressMax: benchPressMax,
      deadliftMax: deadliftMax,
    );

    setState(() {
      _calculatedLevel = level;
    });
  }

  void _completeRegistration() {
    // Здесь логика завершения регистрации
    print("Регистрация завершена!");
    print("Логин: ${_loginController.text}");
    print("Имя: ${_nameController.text}");
    print("Вес: ${_weightController.text}");
    print("Уровень: $_calculatedLevel");
    print("Пол: $_selectedGender");
    // Переход на экран успеха или главную страницу, например
    //Navigator.of(context).pushReplacementNamed('/success');
  }
}
