import 'package:flutter/material.dart';

class TrainingProgramGeneratorScreen extends StatefulWidget {
  @override
  _TrainingProgramGeneratorScreenState createState() =>
      _TrainingProgramGeneratorScreenState();
}

class _TrainingProgramGeneratorScreenState
    extends State<TrainingProgramGeneratorScreen> {
  String? _selectedType;
  int _duration = 2;
  int _daysPerWeek = 3;

  final List<String> _programTypes = ['Пауэрлифтинг', 'Бодибилдинг', 'Кроссфит'];

  void _generateProgram() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите тип программы')),
      );
      return;
    }

    // Здесь ты вызываешь логику генерации (например, чтение JSON из assets)
    print('Тип: $_selectedType, Длительность: $_duration недель, '
        '$_daysPerWeek тренировки в неделю');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Генерация программы'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Выбор типа программы
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Тип программы',
                border: OutlineInputBorder(),
              ),
              items: _programTypes
                  .map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Слайдер длительности
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Длительность: $_duration недель"),
                Slider(
                  min: 2,
                  max: 6,
                  divisions: 2,
                  label: _duration.toString(),
                  value: _duration.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _duration = value.round();
                    });
                  },
                ),
              ],
            ),

            // Кол-во тренировок в неделю
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Тренировок в неделю: $_daysPerWeek"),
                Slider(
                  min: 2,
                  max: 4,
                  divisions: 2,
                  label: _daysPerWeek.toString(),
                  value: _daysPerWeek.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _daysPerWeek = value.round();
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            // Кнопка генерации
            ElevatedButton.icon(
              icon: Icon(Icons.fitness_center),
              label: Text("Сгенерировать программу"),
              onPressed: _generateProgram,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}