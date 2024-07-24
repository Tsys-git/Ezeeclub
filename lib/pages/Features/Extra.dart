import 'package:ezeeclub/controllers/planDetailsController.dart';
import 'package:flutter/material.dart';

class extraF extends StatefulWidget {
  const extraF({super.key});

  @override
  State<extraF> createState() => _extraFState();
}

class _extraFState extends State<extraF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: TextButton(onPressed: (){
        Plandetailscontroller().getPlanDetails("42355", "1");
      }, child: Text("get plan detils")),)
    );
  }
}