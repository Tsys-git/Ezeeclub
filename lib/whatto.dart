
import 'package:ezeeclub/setGoalScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  int stepsGoal = 0;
  int caloriesGoal = 0;
  double durationGoal = 0.0;
  Map<String,String>? _locationMessage;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }


  Future<void> _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stepsGoal = prefs.getInt('stepsGoal') ?? 0;
      caloriesGoal = prefs.getInt('caloriesGoal') ?? 0;
      durationGoal = prefs.getDouble('durationGoal') ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
    String Day = DateFormat.EEEE().format(DateTime.now());
    final List<List<bool>> calendar = [
      [true, true, true, false, true, true, true],
      [true, true, false, true, true, true, false],
      [true, true, true, true, false, false, false],
      [true, true, false, false, true, false, true],
    ];
    int countPresentDays() {
      return calendar.fold(1, (prev, element) {
        return prev + element.where((day) => day).length;
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SetGoalsScreen());
            },
            icon: Icon(Icons.connect_without_contact),
          ),
        ],
        title: Text('Today', style: TextStyle(fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: const [Colors.amber, Colors.orange])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Good Morning!',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Icon(Icons.cloud, color: Colors.black),
                            Text(
                              'Sunny, 25°C',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    Text(
                      Day,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Training Calendar',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Table(
                    children: [
                      TableRow(
                        children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                            .map((day) => Center(
                                    child: Text(
                                  day,
                                  style: TextStyle(color: Colors.white),
                                )))
                            .toList(),
                      ),
                      for (var week in calendar)
                        TableRow(
                          children: week
                              .map((active) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          active ? Colors.green : Colors.red,
                                      radius: 10,
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Present Days :',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.whatshot, color: Colors.orange),
                      SizedBox(width: 5),
                      Text(
                        '${countPresentDays()} DAYS',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Active days = ', style: TextStyle(fontSize: 18)),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Absent days = ', style: TextStyle(fontSize: 18)),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFF1D2434),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steps',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'step count record',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 15000,
                        barTouchData: BarTouchData(
                          allowTouchBarBackDraw: true,
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.green,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String weekDay;
                              switch (group.x) {
                                case 0:
                                  weekDay = 'Monday';
                                  break;
                                case 1:
                                  weekDay = 'Tuesday';
                                  break;
                                case 2:
                                  weekDay = 'Wednesday';
                                  break;
                                case 3:
                                  weekDay = 'Thursday';
                                  break;
                                case 4:
                                  weekDay = 'Friday';
                                  break;
                                case 5:
                                  weekDay = 'Saturday';
                                  break;
                                case 6:
                                  weekDay = 'Sunday';
                                  break;
                                default:
                                  throw Error();
                              }
                              return BarTooltipItem(
                                weekDay +
                                    '\n' +
                                    (rod.toY / 1000).toString() +
                                    "K",
                                TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        barGroups: [
                          makeGroupData(0, 5000),
                          makeGroupData(1, 6500),
                          makeGroupData(2, 5000),
                          makeGroupData(3, 7000),
                          makeGroupData(4, 9000),
                          makeGroupData(5, 1500),
                          makeGroupData(6, 6000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Summary',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ActivitySummaryItem(
                            icon: Icons.directions_run,
                            label: 'Steps',
                            value: stepsGoal
                                .toString()), // Replace with actual value
                        ActivitySummaryItem(
                            icon: Icons.local_fire_department,
                            label: 'Calories',
                            value: caloriesGoal
                                .toString()), // Replace with actual value
                        ActivitySummaryItem(
                            icon: Icons.access_time,
                            label: 'Duration',
                            value: durationGoal
                                .toString()), // Replace with actual value
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goals Today',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    GoalItem(
                      goal: 'Complete $stepsGoal steps',
                      isCompleted: stepsGoal > 2000
                          ? true
                          : false, // Example, can be dynamic
                    ),
                    GoalItem(
                      goal: 'Burn $caloriesGoal calories',
                      isCompleted: caloriesGoal > 800
                          ? true
                          : false, // Example, can be dynamic
                    ),
                    GoalItem(
                      goal:
                          'Exercise for ${durationGoal.toStringAsFixed(1)} hours',
                      isCompleted: durationGoal < 1.4
                          ? true
                          : false, // Example, can be dynamic
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Scheduled Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 300, // Limit height for ListView
              child: ListView(
                shrinkWrap: true,
                children: const [
                  ScheduledActivityItem(
                    time: '09:00 AM',
                    activity: 'Morning Yoga',
                    instructor: 'John Doe',
                  ),
                  ScheduledActivityItem(
                    time: '05:00 PM',
                    activity: 'Strength Training',
                    instructor: 'Jane Smith',
                  ),
                  ScheduledActivityItem(
                    time: '07:00 PM',
                    activity: 'Zumba Dance',
                    instructor: 'Emily Brown',
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nutrition Summary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Calories: 1500\nProtein: 80g\nCarbs: 200g',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Motivational Quote',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '"Success usually comes to those who are too busy to be looking for it."',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Henry David Thoreau',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Water Intake Tracker',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '... Ml',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Achievements/Badges',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BadgeItem(
                          badge: '10000\nSteps\nBadge',
                          icon: Icons.directions_run,
                          earned: true,
                        ),
                        BadgeItem(
                          badge: '500\nCal Burned\nBadge',
                          icon: Icons.local_fire_department,
                          earned: true,
                        ),
                        BadgeItem(
                          badge: '30\nDays Streak\nBadge',
                          icon: Icons.star,
                          earned: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sleep Tracking Integration',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '7 hours and 30 minutes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Progress Tracking with Charts',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      // Replace with actual chart widget
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Customizable Widgets',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Coming Soon!',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Add more sections as needed
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, {bool isTouched = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched ? Colors.green : Colors.white,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 15000,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class BadgeItem extends StatelessWidget {
  final String badge;
  final IconData icon;
  final bool earned;

  const BadgeItem({
    super.key,
    required this.badge,
    required this.icon,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.white),
        SizedBox(height: 8),
        Center(
          child: Text(
            badge,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 4),
        Text(
          earned ? 'Earned' : 'Locked',
          style: TextStyle(
            fontSize: 14,
            color: earned ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ActivitySummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ActivitySummaryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.white),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class ScheduledActivityItem extends StatelessWidget {
  final String time;
  final String activity;
  final String instructor;

  const ScheduledActivityItem({
    super.key,
    required this.time,
    required this.activity,
    required this.instructor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(Icons.self_improvement, color: Colors.white),
        ),
        title: Text(activity),
        subtitle: Text('$time - $instructor'),
        trailing: IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: () {
            // Navigate to activity details
          },
        ),
      ),
    );
  }
}

class GoalItem extends StatelessWidget {
  final String goal;
  final bool isCompleted;

  const GoalItem({
    super.key,
    required this.goal,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted ? Colors.green : Colors.grey,
        child: Icon(
          isCompleted ? Icons.check : Icons.access_time,
          color: Colors.white,
        ),
      ),
      title: isCompleted
          ? Text(
              goal,
              style: TextStyle(
                color: Colors.green,
                decoration: TextDecoration.lineThrough,
              ),
            )
          : Text(goal, style: TextStyle(color: Colors.grey)),
      trailing: isCompleted
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.radio_button_unchecked),
    );
  }
}
