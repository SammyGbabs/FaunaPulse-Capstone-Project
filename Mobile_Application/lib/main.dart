import 'package:fauna_pulse/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fauna_pulse/config/themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// MyApp widget
/// This widget is the root of the application.
/// It sets up the MaterialApp with a title, theme, and home screen.
/// The home screen is the SplashScreen.
/// The app uses a custom theme defined in the AppTheme class.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtubHRvd2psb3FqZnlvamJuYnhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzNTIyODUsImV4cCI6MjA2NjkyODI4NX0.9QUIjZjKZXYcAyqjxXw6cpeAa13GZf01xXr5j29lkYU",
    url: 'https://knltowjloqjfyojbnbxc.supabase.co',
  );
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