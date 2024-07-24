import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetGoalsScreen extends StatefulWidget {
  const SetGoalsScreen({super.key});

  @override
  _SetGoalsScreenState createState() => _SetGoalsScreenState();
}

class _SetGoalsScreenState extends State<SetGoalsScreen> {
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stepsGoal', int.tryParse(_stepsController.text) ?? 0);
      await prefs.setInt(
          'caloriesGoal', int.tryParse(_caloriesController.text) ?? 0);
      await prefs.setDouble(
          'durationGoal', double.tryParse(_durationController.text) ?? 0.0);

      // Navigate back to previous screen or home screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GoalInputField(
                labelText: 'Steps',
                controller: _stepsController,
                unit: 'steps',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GoalInputField(
                labelText: 'Calories',
                controller: _caloriesController,
                unit: 'calories',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GoalInputField(
                labelText: 'Duration',
                controller: _durationController,
                unit: 'hours',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveGoals,
                child: Text('Set Goals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String unit;
  final FormFieldValidator<String>? validator;

  const GoalInputField({super.key, 
    required this.labelText,
    required this.controller,
    required this.unit,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '$labelText Goal ($unit)',
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
