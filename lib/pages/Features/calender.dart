import 'package:ezeeclub/consts/userLogin.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import for date formatting

import '../../controllers/calenderController.dart';
import '../../models/calender.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController = CalendarController();
  List<CalendarEvent> _calendarEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String member_no = "";
  String branchno = "";

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  Future<void> loaddata() async {
    UserLogin userLogin = UserLogin();
    String? memberNo = await userLogin.getMemberNo();
    String? branchNo = await userLogin.getBranchNo();
    setState(() {
      member_no = memberNo ?? "";
      branchno = branchNo ?? "";
    });
    fetchCalendarEvents(member_no, branchno);
  }

  Future<void> fetchCalendarEvents(String memberNo, String branchNo) async {
    try {
      // Determine the month and year based on the selected date, or use the current date if none is selected
      final selectedMonth = _selectedDay != null
          ? DateFormat('M').format(_selectedDay!)
          : DateFormat('M').format(DateTime.now());
      final selectedYear = _selectedDay != null
          ? DateFormat('yyyy').format(_selectedDay!)
          : DateFormat('yyyy').format(DateTime.now());

      // Fetch calendar events using the selected date, month, and year
      _calendarEvents = await _calendarController.getCalendarDetails(
        memberNo,
        branchNo,
        selectedMonth,
        selectedYear,
      );
      setState(() {}); // Update UI after fetching events
    } catch (e) {
      print('Error fetching calendar events: $e');
    }
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    print(day);

    final DateFormat dateFormat =
        DateFormat("M/d/yyyy h:mm:ss a"); // Adjust format if needed
    return _calendarEvents.where((event) {
      if (event.messageNo == null || event.messageNo!.isEmpty) return false;
      try {
        //DateTime eventDate = dateFormat.parse(event.messageNo!);
        DateTime eventDate =
            DateFormat("M/d/yyyy h:mm:ss a").parse(event.messageNo);
        return isSameDay(day, eventDate);
      } catch (e) {
        print('Error parsing date: $e');
        return false;
      }
    }).toList();
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
                    fetchCalendarEvents(member_no,
                        branchno); // Fetch events for the selected day
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
                child: Builder(
                  builder: (context) {
                    final eventsForSelectedDay =
                        getEventsForDay(_selectedDay ?? DateTime.now());
                    if (eventsForSelectedDay.isEmpty) {
                      return Center(
                        child: Text(
                          'No message for this date',
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: eventsForSelectedDay.length,
                        itemBuilder: (context, index) {
                          final event = eventsForSelectedDay[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                event.message ?? 'No message',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (event.messageNo != "")
                                    Text(
                                      'Date: ${formatDate(event.messageNo!)}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  if (event.empName != "")
                                    Text(
                                      'Employee Name: ${event.empName}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  if (event.branchNo != null)
                                    Text(
                                      'Branch No: ${event.branchNo}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  if (event.status != null)
                                    Text(
                                      'Status: ${event.status}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  // Add other fields as needed
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
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
        color: Colors.green.shade200,
      ),
      selectedDecoration: BoxDecoration(
        color: Colors.green.shade400,
      ),
      weekendTextStyle: TextStyle(color: Colors.green.shade800),
      holidayTextStyle: TextStyle(color: Colors.green.shade800),
      outsideTextStyle: TextStyle(color: Colors.grey),
      outsideDaysVisible: false,
      todayTextStyle: TextStyle(
        color: Colors.green.shade900,
        fontWeight: FontWeight.bold,
      ),
      markerDecoration: BoxDecoration(
        color: Colors.green.shade600,
      ),
    );
  }

  String formatDate(String dateString) {
    try {
      final DateTime date = DateFormat("M/d/yyyy h:mm:ss a").parse(dateString);
      return DateFormat("MMMM d, yyyy h:mm a").format(date);
    } catch (e) {
      print('Error formatting date: $e');
      return dateString;
    }
  }
}
