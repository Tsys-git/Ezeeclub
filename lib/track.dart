import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrackYourProgress extends StatelessWidget {
  const TrackYourProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Progress'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: TrackYourProgressWidget(),
      ),
    );
  }
}

class TrackYourProgressWidget extends StatefulWidget {
  const TrackYourProgressWidget({super.key});

  @override
  _TrackYourProgressWidgetState createState() =>
      _TrackYourProgressWidgetState();
}

class _TrackYourProgressWidgetState extends State<TrackYourProgressWidget> {
  final List<ProgressData> progressData = [
    ProgressData('Jan', 200),
    ProgressData('Feb', 300),
    ProgressData('Mar', 400),
    ProgressData('Apr', 500),
    ProgressData('May', 600),
    ProgressData('Jun', 700),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Track Your Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.0),
          _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          barGroups: progressData
              .asMap()
              .map((index, data) => MapEntry(
                    index,
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data.value.toDouble(),
                          color: Colors.blue,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                  ))
              .values
              .toList(),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 100 == 0,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.grey, strokeWidth: 0.5);
            },
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String month = progressData[group.x.toInt()].month;
                int value = progressData[group.x.toInt()].value;
                return BarTooltipItem(
                  '$month\n$value',
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressData {
  final String month;
  final int value;

  ProgressData(this.month, this.value);
}
