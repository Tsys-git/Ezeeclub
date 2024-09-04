import 'package:flutter/material.dart';

class DashboardOption extends StatefulWidget {
  final String title;
  final Function onTap;
  final String img;

  const DashboardOption(
      {super.key, required this.title, required this.onTap, required this.img});

  @override
  State<DashboardOption> createState() => _DashboardOptionState();
}

class _DashboardOptionState extends State<DashboardOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                          color: Color.fromARGB(70, 65, 168, 228),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  widget.img,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
