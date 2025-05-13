import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_testosterone/services/user_services.dart';
import 'package:only_testosterone/widgets/custom_text_field.dart';
import 'package:only_testosterone/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:only_testosterone/services/user_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Контроллеры ввода
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _squatController = TextEditingController();
  final _benchController = TextEditingController();
  final _deadliftController = TextEditingController();

  int _calculatedLevel = 0;
  String _selectedGender = 'М';

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _squatController.dispose();
    _benchController.dispose();
    _deadliftController.dispose();
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
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  /// Шаг 1: логин и пароль
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: 'Логин',
            controller: _loginController,
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

  /// Шаг 2: имя, вес и пол
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: 'Имя',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Вес (кг)',
            controller: _weightController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text('Пол', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGenderChoice('М'),
              const SizedBox(width: 10),
              _buildGenderChoice('Ж'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChoice(String gender) {
    return ChoiceChip(
      label: Text(gender),
      selected: _selectedGender == gender,
      onSelected: (selected) {
        setState(() => _selectedGender = gender);
      },
    );
  }

  /// Шаг 3: силовые показатели
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
            "Ваш уровень подготовки: ${_getLevelText(_calculatedLevel)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Нижняя панель навигации (Назад/Далее/Завершить)
  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            _buildNavButton("Назад", _previousStep),
          _buildNavButton(_currentStep < 2 ? "Далее" : "Завершить", _onNextOrFinish),
        ],
      ),
    );
  }

  /// Создание кнопки навигации
  Widget _buildNavButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(140, 45),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text),
    );
  }

  void _previousStep() {
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() => _currentStep--);
  }

  Future<void> _onNextOrFinish() async {
    bool isValid = await _validateStep();
    if (!isValid) return;

    if (_currentStep < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() => _currentStep++);
    } else {
      _completeRegistration();
    }
  }

  /// Проверка корректности данных на каждом шаге
  Future<bool> _validateStep() async {
    switch (_currentStep) {
      case 0:
        if (_loginController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
          _showError("Пожалуйста, заполните все поля.");
          return false;
        }
        if (_passwordController.text != _confirmPasswordController.text) {
          _showError("Пароли не совпадают.");
          return false;
        }
        if (await UserServices.isLoginTaker(_loginController.text)) {
          _showError("Такой логин уже занят.");
          return false;
        }
        break;

      case 1:
        if (_nameController.text.isEmpty || _weightController.text.isEmpty) {
          _showError("Введите имя и вес.");
          return false;
        }
        if (double.tryParse(_weightController.text) == null) {
          _showError("Вес должен быть числом.");
          return false;
        }
        break;

      case 2:
        if (_squatController.text.isEmpty || _benchController.text.isEmpty || _deadliftController.text.isEmpty) {
          _showError("Заполните все силовые показатели.");
          return false;
        }
        break;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Возвращает текстовое описание уровня подготовки
  String _getLevelText(int level) {
    switch (level) {
      case 0: return 'Начальный уровень подготовки';
      case 1: return 'Средний уровень подготовки';
      case 2: return 'Продвинутый уровень подготовки';
      default: return 'Неизвестный уровень';
    }
  }

  /// Обновление уровня подготовки при изменении значений
  void _updateTrainingLevel() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final squatMax = double.tryParse(_squatController.text) ?? 0;
    final benchMax = double.tryParse(_benchController.text) ?? 0;
    final deadliftMax = double.tryParse(_deadliftController.text) ?? 0;

    final level = UserServices.determineTrainingLevel(
      gender: _selectedGender,
      weight: weight,
      squatMax: squatMax,
      benchPressMax: benchMax,
      deadliftMax: deadliftMax,
    );

    setState(() => _calculatedLevel = level);
  }

  /// Завершение регистрации и переход в приложение
  void _completeRegistration() async {
    UserModel user = UserModel(
      name: _nameController.text,
      login: _loginController.text,
      password: _passwordController.text,
      weight: double.tryParse(_weightController.text),
      gender: _selectedGender,
      benchPress: double.tryParse(_benchController.text),
      squat: double.tryParse(_squatController.text),
      deadLift: double.tryParse(_deadliftController.text),
      levelOfTraining: _calculatedLevel,
      dailyCalories: 0.0,
    );

    int? userId = await UserServices.registerUser(user);

    if (userId != null) {
      await UserPreferences.saveUserId(userId);
      context.push('/home');
    } else {
      _showError("Ошибка при регистрации.");
    }
  }
}
