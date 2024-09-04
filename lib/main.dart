import 'package:device_preview/device_preview.dart';
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
 runApp(
    DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark, // This will use the dark theme
        home: SplashScreen());
  }
}


// Asset validation failed
// Invalid bundle. The “UIInterfaceOrientationPortrait” orientations were provided for the 
//UISupportedInterfaceOrientations Info.plist key in the com.tsysinfoios.ezeeclub bundle, 
//but you need to include all of the “UIInterfaceOrientationPortrait,UIInterfaceOrientationPortraitUpsideDown,
//UIInterfaceOrientationLandscapeLeft,UIInterfaceOrientationLandscapeRight” orientations to support iPad multitasking.
// For details, visit: 
//https://developer.apple.com/documentation/bundleresources/information_property_list/uisupportedinterfaceorientations. 
//(ID: f6773889-8c2c-4fac-8092-de63adbb2c86)

// Asset validation failed
// SDK version issue. This app was built with the iOS 16.0 SDK. All iOS and iPadOS apps must be built with the iOS 17 SDK or later, 
//included in Xcode 15 or later, in order to be uploaded to App Store Connect or submitted for distribution.
// (ID: 724dc550-422e-4046-88d9-175d9e98a7a9)