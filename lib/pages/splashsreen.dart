import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../consts/appConsts.dart';
import '../consts/userLogin.dart';
import '../seturlScreen.dart';
import 'Auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppConsts ap = AppConsts();
  String? storedUrl;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getUrl();

    // Print the initial URL value
    print('Current URL value: ${storedUrl}');

    // Load URL from SharedPreferences and navigate after delay
    _loadAndNavigate();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await UserLogin().restoreLoginState(); // Ensure login state is restored
    setState(() {
      isLoggedIn = UserLogin().isLoggedIn; // Update isLoggedIn state
    });

    if (isLoggedIn) {
      // If logged in, navigate to Dashboard
      navigateToDashboard();
    }
  }

  void navigateToDashboard() {
     }

  void getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    storedUrl = prefs.getString('app_url');
    print('Current URL value: ${storedUrl}');
  }

  // Method to load URL from SharedPreferences and navigate
  Future<void> _loadAndNavigate() async {
    await ap.loadUrlFromPrefs();

    // Navigate to appropriate screen after 2 seconds
    Timer(Duration(seconds: 6), () {
      if (storedUrl != null && storedUrl!.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Navigate to SetUrlScreen if storedUrl is empty
        Get.off(() => SetUrlScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Image.asset(
            'assets/splashScreen.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App name
                Text(
                  'Ezee Club',
                  style: TextStyle(
                    fontSize: 54,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Motivational message
                Text(
                  "Every Drop of Sweat Takes \nYou Closer to Success.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32),
                // Progress indicator
                LinearProgressIndicator(color: Theme.of(context).primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
