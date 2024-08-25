import 'package:flutter/material.dart';
import 'screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      title: 'Hurawatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 37, 60)),
        useMaterial3: true,
        highlightColor: const Color.fromARGB(255, 0, 31, 53),
        splashColor: const Color.fromARGB(255, 0, 17, 34),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
