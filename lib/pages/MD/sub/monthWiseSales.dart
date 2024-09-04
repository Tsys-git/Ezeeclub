import 'package:ezeeclub/pages/MD/detailsRecipt.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesMonthWise extends StatefulWidget {
  final Map<String, dynamic> dataSales;
  final String BranchNo;
  final String BrancName;

  const SalesMonthWise({
    super.key,
    required this.dataSales,
    required this.BranchNo,
    required this.BrancName,
  });

  @override
  State<SalesMonthWise> createState() => _SalesMonthWiseState();
}

class _SalesMonthWiseState extends State<SalesMonthWise> {
  // Function to generate DataRows for each month
  List<DataRow> generateDataRows(List<String> months) {
    return months.map((month) {
      var amount = widget.dataSales[month];
      return DataRow(cells: [
        DataCell(GestureDetector(
            onTap: () {
              print(month);
              var startDateEndDate = getStartDateAndEndDate(month);
              Get.to(() => DetailsReceipt(
                  startDate: startDateEndDate['startDate']!,
                  endDate: startDateEndDate['endDate']!,
                  branchNo: widget.BranchNo,
                  branchName: widget.BrancName));
            },
            child: Text(month, style: TextStyle(color: Colors.white)))),
        DataCell(Text(
          amount != null ? amount.toString() : 'N/A',
          style: TextStyle(color: Colors.white),
        )),
      ]);
    }).toList();
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // DataTable for the year
    Widget yearTable = Card(
      color: Color.fromARGB(70, 65, 168, 228),
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text('Month',
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
          DataColumn(
            label: Text('Amount',
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ],
        rows: generateDataRows([
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ]),
      ),
    );

    // Pie chart data
    List<PieChartSectionData> pieChartSections = [
      for (var entry in widget.dataSales.entries)
        PieChartSectionData(
          value: parseDoubleValue(entry.value),
          title: "${entry.key}\n${entry.value}",
          color: getColor(entry.key),
          radius: width * 0.4,
          titleStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
    ];

    // Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.BrancName,
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sales Contribution in Year ${DateTime.now().year} [ PIE CHART ]",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: width * 0.8, // Adjust height as needed
                width: double.infinity,
                child: Center(
                  child: PieChart(
                    PieChartData(
                      sections: pieChartSections,
                      centerSpaceRadius: 0,
                      startDegreeOffset: 180,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sales Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: yearTable,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to parse double value safely
  double parseDoubleValue(dynamic value) {
    if (value is int || value is double) {
      return value.toDouble();
    } else if (value is String) {
      if (value.isNotEmpty) {
        return double.tryParse(value) ?? 0.0; // Handle invalid parse
      }
    }
    return 0.0; // Default value if parsing fails
  }

  // Helper method to assign colors to pie chart sections
  Color getColor(String month) {
    switch (month) {
      case 'January':
        return Colors.red;
      case 'February':
        return Colors.orange;
      case 'March':
        return Colors.yellow;
      case 'April':
        return Colors.green;
      case 'May':
        return Color.fromARGB(220, 64, 240, 208);
      case 'June':
        return Color.fromRGBO(255, 0, 255, 0.7);
      case 'July':
        return Color.fromRGBO(255, 218, 185, 0.6);
      case 'August':
        return Color.fromARGB(150, 144, 0, 0);
      case 'September':
        return Colors.blue;
      case 'October':
        return Colors.amber;
      case 'November':
        return Color.fromRGBO(255, 127, 80, 0.6);
      case 'December':
        return Color.fromRGBO(112, 128, 144, 0.6);
      default:
        return Colors.grey;
    }
  }

  // Helper method to get start and end date of the month
  Map<String, String> getStartDateAndEndDate(String month) {
    DateTime now = DateTime.now();
    int year = now.year;
    int startDay = 1;
    int endDay;

    switch (month) {
      case 'January':
        endDay = 31;
        break;
      case 'February':
        endDay = (DateTime.now().year % 4 == 0) ? 29 : 28;
        break;
      case 'March':
        endDay = 31;
        break;
      case 'April':
        endDay = 30;
        break;
      case 'May':
        endDay = 31;
        break;
      case 'June':
        endDay = 30;
        break;
      case 'July':
        endDay = 31;
        break;
      case 'August':
        endDay = 31;
        break;
      case 'September':
        endDay = 30;
        break;
      case 'October':
        endDay = 31;
        break;
      case 'November':
        endDay = 30;
        break;
      case 'December':
        endDay = 31;
        break;
      default:
        endDay = 0;
    }

    int monthIndex = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ].indexOf(month) +
        1;

    DateTime startDate = DateTime(year, monthIndex, startDay);
    DateTime endDate = DateTime(year, monthIndex, endDay);

    return {
      'startDate': DateFormat('dd/MM/yyyy').format(startDate),
      'endDate': DateFormat('dd/MM/yyyy').format(endDate),
    };
  }
}
