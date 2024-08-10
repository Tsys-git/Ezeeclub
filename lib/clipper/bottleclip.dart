import 'dart:ui';

import 'package:flutter/material.dart';

class BottleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.4, 0);
    path.lineTo(size.width * 0.6, 0);
        path.lineTo(size.width * 0.6, 0);
    path.lineTo(size.width * 0.6, 0);

    path.lineTo(size.width * 0.6, size.height * 0.1);
    path.quadraticBezierTo(
        size.width, size.height * 0.2, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(size.width, size.height, size.width * 0.5, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height * 0.7);
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(0, size.height * 0.2, size.width * 0.4, size.height * 0.1);
    path.lineTo(size.width * 0.4, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}