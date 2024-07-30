import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'consts/URL_Setting.dart';
import 'consts/theme.dart';
import 'package:get/get.dart';
import 'pages/splashsreen.dart';

Future main() async {
    UrlSetting urlSetting = UrlSetting();

  WidgetsFlutterBinding.ensureInitialized();
  await urlSetting.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark, // This will use the system theme
      home: SplashScreen(),
    );
  }
}
