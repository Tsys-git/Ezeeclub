import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';

class BodyPartSelector extends StatefulWidget {
   const BodyPartSelector({required this.title, super.key});

  final String title;

  @override
  State<BodyPartSelector> createState() => _BodyPartSelectorState();
}

class _BodyPartSelectorState extends State<BodyPartSelector> {
  BodyParts _bodyParts = const BodyParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: BodyPartSelectorTurnable(
          bodyParts: _bodyParts,
          onSelectionUpdated: (selectedBodyParts) {
            setState(() {
              _bodyParts = selectedBodyParts;
            });

            // Print the selected body parts
            print('Selected Body Parts: ${selectedBodyParts}');
          },
        ),
      ),
    );
  }
}
