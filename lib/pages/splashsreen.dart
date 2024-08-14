import 'dart:async';
import 'package:ezeeclub/pages/HomeScreenMember.dart';
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
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await UserLogin().restoreLoginState(); // Ensure login state is restored
    setState(() {
      isLoggedIn = UserLogin().isLoggedIn; // Update isLoggedIn state
    });
    _loadAndNavigate(isLoggedIn);
  }

  void getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedUrl = prefs.getString('app_url');
    print('Current URL value: $storedUrl');
  }

  Future<void> _loadAndNavigate(bool isLoggedIn) async {
    await ap.loadUrlFromPrefs();
    print("use login status : $isLoggedIn");

    Timer(Duration(seconds: 5), () {
      Widget nextPage;

      if (isLoggedIn) {
        nextPage = HomeScreenMember();
      } else if (storedUrl != null && storedUrl!.isNotEmpty) {
        nextPage = LoginScreen();
      } else {
        nextPage = SetUrlScreen();
      }

      Get.to(() => nextPage,
          transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/splashscreene.png',
              height: 250,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Developed By Tsysinfo Technologies',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Copyrights © 2024',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
