import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class SplashScreen extends StatefulWidget {
  final int ott;
  const SplashScreen({super.key, required this.ott});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController controller1, controller2, controller3;

  @override
  void initState() {
    controller1 = GifController(vsync: this);
    controller2 = GifController(vsync: this);
    super.initState();

    controller1.addListener(
      () {
        if (controller1.isCompleted) {
          Navigator.pushNamed(context, '/main');
        }
      },
    );

    controller2.addListener(
      () {
        if (controller2.isCompleted) {
          Navigator.pushNamed(context, '/prime');
        }
      },
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.ott == 0
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Gif(
                // fps: 30,
                autostart: Autostart.once,
                // placeholder: (context) =>
                //     const Center(child: CircularProgressIndicator()),
                image: const AssetImage('lib/assets/images/netflix.gif'),
                controller: controller1,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Gif(
                controller: controller2,
                // fps: 30,
                autostart: Autostart.once,
                fit: BoxFit.fitWidth,
                // placeholder: (context) =>
                //     const Center(child: CircularProgressIndicator()),
                image: const AssetImage('lib/assets/images/prime.gif'),
              ),
            ),
          );
  }
}
