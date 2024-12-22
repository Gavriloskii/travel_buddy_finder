import 'package:flutter/material.dart';
import 'package:travel_buddy_finder/screens/auth/login_screen.dart';
import 'package:travel_buddy_finder/screens/auth/signup_screen.dart';
import 'package:travel_buddy_finder/screens/home/home_screen.dart';
import 'package:travel_buddy_finder/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Buddy Finder',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // TODO: Change back to '/login' after testing
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
