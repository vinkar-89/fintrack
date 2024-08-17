import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'backend.dart';
import 'expense_screen.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(MyApp());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  // Add time delay and app logo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Loading page'),
    ));
  }
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  bool isLoggedIn = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pense',
      home: isLoggedIn ? LoginScreen() : SignUpScreen(),
      // home: AddExpenseScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => HomeScreen(),
      //   '/add': (context) => AddExpenseScreen(),
      //   '/log': (context) => LoginScreen(),
      // },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    ProfileScreen(),
    MainScreen(),
    AddExpenseScreen(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: "Add"),
        ],
      ),
    );
  }
}
