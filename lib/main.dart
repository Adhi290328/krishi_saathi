import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'crops_screen.dart';
import 'settings_screen.dart';
import 'weather_screen.dart';

void main() {
  runApp(const KrishiSaathiApp());
}

class KrishiSaathiApp extends StatelessWidget {
  const KrishiSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Krishi Saathi",
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CropsScreen(),
    WeatherScreen(),  // Weather logic is in weather_screen.dart
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: "Crops",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: "Weather",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
