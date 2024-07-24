import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/calenderController.dart';
import '../../models/calender.dart';

class CalendarScreen extends StatefulWidget {
  final String memberNo;
  final String branchNo;

  const CalendarScreen({
    super.key,
    required this.memberNo,
    required this.branchNo,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController = CalendarController();
  List<CalendarEvent> _calendarEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    fetchCalendarEvents();
  }

  Future<void> fetchCalendarEvents() async {
    try {
      _calendarEvents = await _calendarController.getCalendarDetails(
        widget.memberNo,
        widget.branchNo,
        DateTime.now().month.toString(),
        // "6",
        DateTime.now().year.toString(),
        // "2023"
      );
      setState(() {}); // Update UI after fetching events
    } catch (e) {
      print('Error fetching calendar events: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar ${DateTime.now().year}"),
      ),
      body: Center(
        child: Card(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2021, 1, 1),
                lastDay: DateTime.utc(2040, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: HeaderStyle(),
                calendarStyle: customCalendarStyle(),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Card(
                  child: ListView.builder(
                    itemCount: _calendarEvents.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: ListTile(
                          title: Text(_calendarEvents[index].attachment),
                          subtitle: Text(_calendarEvents[index].sendDt),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CalendarStyle customCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: Colors.orange.shade200,
      ),
      selectedDecoration: BoxDecoration(
        color: Colors.orange.shade400,
      ),
      weekendTextStyle: TextStyle(color: Colors.orange.shade800),
      holidayTextStyle: TextStyle(color: Colors.orange.shade800),
      outsideTextStyle: TextStyle(color: Colors.grey),
      outsideDaysVisible: false,
      todayTextStyle: TextStyle(
        color: Colors.orange.shade900,
        fontWeight: FontWeight.bold,
      ),
      markerDecoration: BoxDecoration(
        color: Colors.orange.shade600,
      ),
    );
  }
}
