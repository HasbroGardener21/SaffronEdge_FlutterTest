import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const FocusLadderApp());

class FocusLadderApp extends StatelessWidget {
  const FocusLadderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF121212),
          onSurface: Color(0xFFE0E0E0),
        ),
        fontFamily: 'monospace', // Crisp technical font feel for numbers
      ),
      home: const HomeScreen(),
    );
  }
}