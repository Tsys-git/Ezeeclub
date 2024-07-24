import 'package:flutter/material.dart';

class Slotbooking extends StatefulWidget {
  const Slotbooking({super.key});

  @override
  State<Slotbooking> createState() => _SlotbookingState();
}

class _SlotbookingState extends State<Slotbooking> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.orange),
          title: Text('Slot Booking', style: TextStyle(color: Colors.white)),
          elevation: 0.0,
        ),
        body: Text("Slot Booking"));
  }
}
