import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.black, fontSize: 20),
    titleMedium: TextStyle(color: Colors.grey, fontSize: 12),
  ),
  cardColor: Colors.white,
  cardTheme: CardTheme(shadowColor: Colors.white),
  primaryColor: Colors.deepPurple[300],
  iconTheme: IconThemeData(color: Colors.deepPurple),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.white, fontSize: 20),
    titleMedium: TextStyle(color: Colors.grey, fontSize: 12),
  ),
  cardColor: Color.fromARGB(255, 79, 0, 12),
  //primaryColor: Color.fromARGB(255, 79, 0, 12),
  primaryColor: Colors.green,
  // fromARGB(255, 38, 174, 228)
  secondaryHeaderColor: Colors.deepOrangeAccent[100],

  iconTheme: IconThemeData(color: Colors.white),
);

//

class ThemeColors {
  static const Color color1D3461 = Color(0xFF1D3461);
  static const Color color1F487E = Color(0xFF1F487E);
  static const Color color376996 = Color(0xFF376996);
  static const Color color6290C8 = Color(0xFF6290C8);
  static const Color color829CBC = Color(0xFF829CBC);
}

// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: Colors.black,
//   appBarTheme: AppBarTheme(

//     backgroundColor: Colors.black,
//     titleTextStyle: TextStyle(color: Colors.white),
//   ),
//   textTheme: TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     bodyMedium: TextStyle(color: Colors.white),
//     bodySmall: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold ),
//     titleLarge: TextStyle(color: Colors.white, fontSize: 20),
//     titleMedium: TextStyle(color: Colors.grey, fontSize: 12),
//   ),
//   cardColor: Color.fromARGB(255, 43, 42, 42),
//   primaryColor: Colors.purple[200],
//  secondaryHeaderColor: Colors.deepOrangeAccent[100],

//     // fromARGB(255, 38, 174, 228)

//   iconTheme: IconThemeData(color: Colors.white),
// );

// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: Colors.black,
//   appBarTheme: AppBarTheme(

//     backgroundColor: Colors.black,
//     titleTextStyle: TextStyle(color: Colors.white),
//   ),
//   textTheme: TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     bodyMedium: TextStyle(color: Colors.white),
//     bodySmall: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold ),
//     titleLarge: TextStyle(color: Colors.white, fontSize: 20),
//     titleMedium: TextStyle(color: Colors.grey, fontSize: 12),
//   ),
//   cardColor: Color.fromARGB(255, 43, 42, 42),
//   primaryColor: Colors.green[200],
//  secondaryHeaderColor: Colors.green[100],

//     // fromARGB(255, 38, 174, 228)

//   iconTheme: IconThemeData(color: Colors.white),
// );
