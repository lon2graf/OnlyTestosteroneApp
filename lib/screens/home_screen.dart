import 'package:flutter/material.dart';
import 'package:only_testosterone/screens/generate_program_screen.dart';
import 'package:only_testosterone/screens/profile_screen.dart';
import 'package:only_testosterone/screens/user_programs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    //здеся можно экраны писать отдельные(осталось их тока реализовать)
    ProfileScreen(),
    TrainingProgramGeneratorScreen(),
    UserProgramsScreen(),
    Center(child: Text('Калькулятор БЖУ')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawerItem(String title) {
    Navigator.pop(context); // закрываем Drawer
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title (в разработке)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('OnlyTestosterone'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text('Меню', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Настройки'),
              onTap: () => _openDrawerItem('Настройки'),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('База знаний'),
              onTap: () => _openDrawerItem('База знаний'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('О программе'),
              onTap: () => _openDrawerItem('О программе'),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Новая'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Мои'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'БЖУ'),
        ],
      ),
    );
  }
}
