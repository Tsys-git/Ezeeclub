import 'package:flutter/material.dart';
import 'Auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0), // Start at the current position
      end: Offset(0, -1), // Slide up
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    ));

    // Start the slide-up animation after 3 seconds
    Future.delayed(Duration(seconds: -2), () {
      _controller!.forward().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _animation!,
        child: Stack(
          children: <Widget>[
            // Background image
            Image.asset(
              'assets/splashScreen.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
            // Text centered on the screen
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Ezee Club',
                    style: TextStyle(
                      fontSize: 54,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Every Drop of Sweat Takes \nYou Closer to Success.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
