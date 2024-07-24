import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/StepsData.dart'; // Import your StepCountData model
import 'stepController.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({super.key});

  @override
  State<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  final StepController stepController = Get.put(StepController());
  late Future<List<StepCountData>> _stepDataFuture;

  @override
  void initState() {
    super.initState();
    _stepDataFuture = stepController.getWeeklyStepCounts(DateTime.now());

    // Print steps data for debugging purposes
    _stepDataFuture.then((stepDataList) {
      for (var stepData in stepDataList) {
        print('Date: ${stepData.date}, Steps: ${stepData.steps}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<StepCountData>>(
          future: _stepDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              List<StepCountData> stepDataList = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Current Steps',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Obx(() => Text(
                        '${stepController.stepCount.value}',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 20),
                  Text(
                    'Weekly Steps',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          
                        ),
                        gridData: FlGridData(show: true),
                        barGroups: List.generate(
                          stepDataList.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: stepDataList[index].steps.toDouble(),
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
