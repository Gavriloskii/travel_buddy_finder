import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_buddy_finder/screens/auth/login_screen.dart';
import 'package:travel_buddy_finder/screens/counter_screen.dart';
import 'package:travel_buddy_finder/screens/auth/signup_screen.dart';
import 'package:travel_buddy_finder/screens/home/home_screen.dart';
import 'package:travel_buddy_finder/theme/app_theme.dart';
import 'package:travel_buddy_finder/providers/message_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessageProvider(),
      child: MaterialApp(
      title: 'Travel Buddy Finder',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // Set to home for launch
      routes: {
        '/counter': (context) => const CounterScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
      ),
    );
  }
}
