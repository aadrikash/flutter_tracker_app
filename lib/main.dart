import 'package:flutter/material.dart';
import 'services/theme_service.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService themeService = ThemeService();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeService,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeService.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightBlue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: SplashScreen(themeService: themeService),
        );
      },
    );
  }
}
