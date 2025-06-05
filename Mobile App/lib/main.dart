import 'package:fauna_pulse/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fauna_pulse/config/themes.dart';

/// MyApp widget
/// This widget is the root of the application.
/// It sets up the MaterialApp with a title, theme, and home screen.
/// The home screen is the SplashScreen.
/// The app uses a custom theme defined in the AppTheme class.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaunaPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}