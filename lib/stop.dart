import 'dart:async';

import 'package:flutter/material.dart';

class TimerStopwatchContainer extends StatefulWidget {
  const TimerStopwatchContainer({super.key});

  @override
  _TimerStopwatchContainerState createState() => _TimerStopwatchContainerState();
}

class _TimerStopwatchContainerState extends State<TimerStopwatchContainer> {
  Duration _timerDuration = Duration(minutes: 30); // Initial timer duration
  Duration _stopwatchDuration = Duration.zero; // Initial stopwatch duration
  bool _isTimerRunning = false;
  bool _isStopwatchRunning = false;
  late DateTime _timerStartTime;
  late DateTime _stopwatchStartTime;

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _timerStartTime = DateTime.now();
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final difference = now.difference(_timerStartTime);
        final remainingTime = _timerDuration - difference;
        if (remainingTime.inSeconds <= 0) {
          _isTimerRunning = false;
          timer.cancel();
        }
      });
    });
  }

  void _startStopwatch() {
    setState(() {
      _isStopwatchRunning = true;
      _stopwatchStartTime = DateTime.now();
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        _stopwatchDuration = now.difference(_stopwatchStartTime);
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _pauseStopwatch() {
    setState(() {
      _isStopwatchRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _timerDuration = Duration(minutes: 30);
    });
  }

  void _resetStopwatch() {
    setState(() {
      _isStopwatchRunning = false;
      _stopwatchDuration = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Timer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _timerDuration.toString().split('.').first.padLeft(8, '0'),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                  child: Text(_isTimerRunning ? 'Pause' : 'Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Stopwatch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _stopwatchDuration.toString().split('.').first.padLeft(8, '0'),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isStopwatchRunning ? _pauseStopwatch : _startStopwatch,
                  child: Text(_isStopwatchRunning ? 'Pause' : 'Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
