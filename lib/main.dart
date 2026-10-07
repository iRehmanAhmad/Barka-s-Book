import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const BarkaBookApp());
}

class BarkaBookApp extends StatelessWidget {
  const BarkaBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Barka's Book",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB703),
          primary: const Color(0xFFFFB703),
          secondary: const Color(0xFF023047),
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            "Barka's Book (بارکہ کی کتاب)",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
