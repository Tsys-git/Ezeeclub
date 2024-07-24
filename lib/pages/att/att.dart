import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:android_intent/android_intent.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../permissions/permissions.dart';

class AttendaceScreen extends StatefulWidget {
  const AttendaceScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AttendaceScreenState();
}

class _AttendaceScreenState extends State<AttendaceScreen> {
  final _locationStreamController = StreamController<Location>();
  final PermissionService permissionService = PermissionService();
  final _activityStreamController = StreamController<Activity>();

  Location? location;
  bool inside = false;

  final DateTime now = DateTime.now();
  int presentDaysCount = 0;
  Map<String, bool> calendar = {
    "20/07/2024": true,
    "21/07/2024": true,
    "22/07/2024": false,
  };
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Create a [GeofenceService] instance and set options.
  final GeofenceService _geofenceService = GeofenceService.instance;

  // Create a [Geofence] list.
  final List<Geofence> _geofenceList = [
    Geofence(
        id: 'TSYSINFO',
        latitude: 18.481501526569087,
        longitude: 73.82656168704091,
        radius: [
          GeofenceRadius(id: 'radius_10m', length: 100),
        ],
        data: "gym location"),
    Geofence(
      id: 'Home Dahitane',
      latitude: 18.5455092031544,
      longitude: 74.21112319147936,
      radius: [
        GeofenceRadius(id: 'radius_25m', length: 25),
        GeofenceRadius(id: 'radius_100m', length: 100),
        GeofenceRadius(id: 'radius_200m', length: 500),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
  }

  void _onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
    _locationStreamController.sink.add(location);
  }

  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    print(geofenceStatus);

    if (geofenceStatus == GeofenceStatus.ENTER ||
        geofenceStatus == GeofenceStatus.DWELL) {
      setState(() {
        inside = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Entered geofence: ${geofence.id} with radius ${geofenceRadius.length} data :${geofence.data}'),
        ),
      );
    } else if (geofenceStatus == GeofenceStatus.EXIT) {
      setState(() {
        inside = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exited geofence: ${geofence.id}'),
        ),
      );
    }
  }

  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

  Future<void> checkAndRequestPermissions() async {
    bool servicesEnabled = await permissionService.isLocationServiceEnabled();
    if (!servicesEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildCustomDialog(context);
        },
      );
      return;
    }

    bool permissionGranted =
        await permissionService.checkAndRequestLocationPermission();
    if (permissionGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _geofenceService.addActivityChangeListener(_onActivityChanged);
        _geofenceService.addLocationChangeListener(_onLocationChanged);
        _geofenceService
            .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
        _geofenceService.start(_geofenceList).catchError((error) {
          print('Error: $error');
        });
      });
    } else {
      print('Location permission not granted');
    }
  }

  Widget _buildCustomDialog(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: width * 1,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/pin.png',
                    height: 50,
                    width: 50,
                    color: Theme.of(context).primaryColor),
                SizedBox(height: 10),
                Text(
                  'Enable Location',
                  style: TextStyle(
                      fontSize: width * 0.1, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'We need to know your location in order to mark your attendance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: width * 0.05),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final AndroidIntent intent = AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                      print("Intent launched ...");
                      intent.launch();
                      Navigator.of(context).pop();
                    },
                    child: Text('Enable', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Not Now',
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showAttendanceMarkedMessage(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: width * 1,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/ok.gif',
                  height: width * 0.2,
                  width: width * 0.5,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(
                  'Well Done!',
                  style: TextStyle(
                      fontSize: width * 0.1, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Your attendance for ${DateFormat.yMMMMd().format(DateTime.now())} is marked successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: width * 0.05),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok', style: TextStyle(fontSize: width * 0.05)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _geofenceService.stop();
    // _locationStreamController.close();
    // _activityStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(DateTime.now().year, 12, 31),
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
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final dayString =
                              DateFormat('dd/MM/yyyy').format(day);
                          bool? isPresent = calendar[dayString];
                          Color backgroundColor;

                          if (isPresent == true) {
                            backgroundColor = Colors.green;
                          } else if (isPresent == false) {
                            backgroundColor = Colors.red;
                          } else {
                            backgroundColor = Colors.transparent;
                          }

                          return Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      headerStyle: HeaderStyle(),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Column(
                children: [
                  inside
                      ? Column(
                          children: [
                            Text(
                              'You are inside the gym.',
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  String todayString = DateFormat('dd/MM/yyyy')
                                      .format(DateTime.now());
                                  calendar[todayString] = true;
                                });
                                print(calendar);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _showAttendanceMarkedMessage(
                                        context);
                                  },
                                );
                              },
                              child: Text('Mark Attendance',
                                  style: TextStyle(fontSize: 18)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'You are outside the gym.',
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
