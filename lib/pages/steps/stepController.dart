import 'dart:async';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/StepsData.dart';

class StepController extends GetxController {
  RxInt stepCount = 0.obs;
  late StreamSubscription<StepCount> _stepCountSubscription;
  late Pedometer _pedometer;

  @override
  void onInit() {
    super.onInit();
    _startPedometer();
    _resetStepsAtMidnight();
  }

  void _startPedometer() {
    _pedometer = Pedometer();
    _stepCountSubscription =
        Pedometer.stepCountStream.listen((StepCount event) {
      stepCount.value = event.steps;
    });
  }

  void _resetStepsAtMidnight() {
    Timer.periodic(Duration(minutes: 60), (timer) async {
      DateTime now = DateTime.now();
      if (now.hour == 3 && now.minute > 0 && now.second > 0) {
        await _saveDailyStepCount();
        stepCount.value = 0;
      }
    });
  }

  Future<List<StepCountData>> getWeeklyStepCounts(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    List<StepCountData> weeklyData = [];

    try {
      for (DateTime day = startOfWeek;
          day.isBefore(endOfWeek) || day.isAtSameMomentAs(endOfWeek);
          day = day.add(Duration(days: 1))) {
        String key = 'stepCount_${day.year}_${day.month}_${day.day}';
        int steps = prefs.getInt(key) ?? 0;
        weeklyData
            .add(StepCountData(date: day.toIso8601String(), steps: steps));
      }
    } catch (e) {
      print('Error fetching weekly step counts: $e');
      // Handle error as per your application's requirements
    }

    return weeklyData;
  }

  Future<void> _saveDailyStepCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String key = 'stepCount_${now.year}_${now.month}_${now.day}';

    try {
      await prefs.setInt(key, stepCount.value);
    } catch (e) {
      print('Error saving daily step count: $e');
      // Handle error as per your application's requirements
    }
  }

  Future<int> getDailyStepCount(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'stepCount_${date.year}_${date.month}_${date.day}';

    try {
      return prefs.getInt(key) ?? 0;
    } catch (e) {
      print('Error fetching daily step count: $e');
      return 0;
    }
  }

  @override
  void onClose() {
    _stepCountSubscription.cancel();
    super.onClose();
  }
}
