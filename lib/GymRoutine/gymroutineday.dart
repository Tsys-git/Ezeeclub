import 'package:ezeeclub/GymRoutine/gymroutine.dart';
import 'package:ezeeclub/controllers/attendanceController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



// Screen widget for managing gym routines
class GymRoutineScreen extends StatefulWidget {
  const GymRoutineScreen({super.key});

  @override
  _GymRoutineScreenState createState() => _GymRoutineScreenState();
}

class _GymRoutineScreenState extends State<GymRoutineScreen> {
  late SharedPreferences _prefs;
  List<GymRoutine> _selectedRoutines = [];
  AttendanceController at = AttendanceController();

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    at.fetchAttendanceData();
  }

  // Initialize SharedPreferences instance and load saved routines
  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedRoutines = _getSavedRoutines() ?? [];
    });
  }

  // Retrieve saved routines from SharedPreferences
  List<GymRoutine>? _getSavedRoutines() {
    List<String>? routineNames = _prefs.getStringList('selected_routines');
    if (routineNames == null) return null;
    return routineNames.map((name) {
      return GymRoutineData.fourDaySplit
          .firstWhere((routine) => routine.name == name);
    }).toList();
  }

  // Save selected routines to SharedPreferences
  void _saveSelectedRoutines() {
    List<String> routineNames =
        _selectedRoutines.map((routine) => routine.name).toList();
    _prefs.setStringList('selected_routines', routineNames);
  }

  // Clear saved routines from SharedPreferences and reset state
  void _resetRoutines() {
    _prefs.remove('selected_routines');
    setState(() {
      _selectedRoutines = [];
    });
  }

  // Toggle routine selection
  void _onToggleRoutine(GymRoutine routine) {
    setState(() {
      if (_selectedRoutines.contains(routine)) {
        _selectedRoutines.remove(routine);
      } else {
        _selectedRoutines.add(routine);
      }
      _saveSelectedRoutines();
    });
  }

  // Build a card widget for each routine
  Widget _buildRoutineCard(GymRoutine routine, int index) {
    bool isSelected = _selectedRoutines.contains(routine);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _onToggleRoutine(routine),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day ${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                routine.description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4-Day Split Gym Routine'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _resetRoutines();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children:
                  GymRoutineData.fourDaySplit.asMap().entries.map((entry) {
                return SizedBox(
                    width: double.infinity,
                    child: _buildRoutineCard(entry.value, entry.key));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
