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
        scaffoldBackgroundColor: const Color(0xFF000000), // True OLED Black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),    // Neon Cyber Cyan for Work
          secondary: Color(0xFF00E676),  // Neon Mint Green for Rest
          surface: Color(0xFF121212),    // Dark Charcoal Cards
          onSurface: Color(0xFFE0E0E0),
        ),
        fontFamily: 'monospace', // Crisp technical font feel for numbers
      ),
      home: const HomeScreen(),
    );
  }
}