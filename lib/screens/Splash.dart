import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome() async {
      // Wait for the duration of the GIF or a few seconds
      await Future.delayed(const Duration(seconds: 3));
      // Navigate to your main screen (e.g., Home screen)
      Navigator.pushReplacementNamed(context, '/main');
    }

    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 350,
        child: Image.asset(
          'lib/assets/images/netflix.gif',
          fit: BoxFit.fitHeight,
        ),
      )),
    );
  }
}
