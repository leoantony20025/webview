import 'package:flutter/services.dart';
import 'package:netflix/screens/MainPrime.dart';

import 'screens/Splash.dart';
import 'package:flutter/material.dart';
import 'screens/Main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MaterialApp(
      title: 'Netflix',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 15, 15, 15)),
          useMaterial3: true,
          highlightColor: const Color.fromARGB(255, 20, 20, 20),
          splashColor: const Color.fromARGB(255, 21, 21, 21),
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 31, 51)),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const SplashScreen(
              ott: 0,
            ),
        '/prime': (context) => const MainPrime(),
        '/main': (context) => const Main(),
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(
        ott: 0,
      ),
    );
  }
}
