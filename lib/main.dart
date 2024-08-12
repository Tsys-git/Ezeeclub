import 'dart:convert';

import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/HomeScreenMember.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'consts/URL_Setting.dart';
import 'consts/theme.dart';
import 'package:get/get.dart';
import 'pages/splashsreen.dart';
import 'package:device_preview/device_preview.dart';



//Error (Xcode): ../../.pub-cache/hosted/pub.dev/syncfusion_flutter_charts-26.1.42/lib/src/charts/common/core_tooltip.dart:168:22: Error: The method 'markNeedsBuild' isn't defined for the class 'RenderConstrainedLayoutBuilder<Constraints, RenderObject>'.
//this error can be resolved by changing markneedsbuild to markneedspaint and markneedslayout.
//ran flutter pub cache repair in terminal 

Future main() async {
  UrlSetting urlSetting = UrlSetting();
  WidgetsFlutterBinding.ensureInitialized();
  await urlSetting.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp()
      // DevicePreview(
      //   enabled: true,
      //   tools: const [
      //     ...DevicePreview.defaultTools,
      //   ],
      //   builder: (context) => MyApp(),
      // ),
      );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  UserModel usermodel = UserModel(
      BranchNo: "1",
      location: "Pune",
      dob: "31/07/1981",
      br_name: "br_name",
      member_no: "42355",
      mem_status: "a",
      fullName: "abc",
      
      phoneNumber: "1234567890",
      email: "abc");

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark, // This will use the system theme
        home: SplashScreen());
  }
}
