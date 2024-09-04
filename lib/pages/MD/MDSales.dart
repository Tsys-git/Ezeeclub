import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:fl_chart/fl_chart.dart';

class MDSalesScreen extends StatefulWidget {
  const MDSalesScreen({super.key});

  @override
  _MDSalesScreenState createState() => _MDSalesScreenState();
}

class _MDSalesScreenState extends State<MDSalesScreen> {
  String MDSales = 'Loading...'; // Placeholder for sales data
  List<String> branchNames = []; // List to store branch names
  Map<String, Map<String, dynamic>> MDSalesByBranch =
      {}; // Map to store sales data by branch

  bool isLoading = false; // Flag to track loading state

  TextEditingController _branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch sales data when the screen initializes
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    // Construct SOAP request
    String soapRequest = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MDSales xmlns="http://tempuri.org/">
      <BranchNo>1</BranchNo>
    </MDSales>
  </soap:Body>
</soap:Envelope>''';

    // Calculate length of SOAP request body
    int contentLength = utf8.encode(soapRequest).length;

    // Make POST request with dynamic Content-Length header
    http.Response response = await http.post(
      Uri.parse('http://oneabovefit.ezeeclub.net/androidwebservice.asmx'),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/MDReceipt',
        'Content-Length': '$contentLength', // Set dynamic Content-Length
      },
      body: soapRequest,
    );

    // Parse XML response and extract branch names and sales
    if (response.statusCode == 200) {
      print(response.body);
      xml.XmlDocument document = xml.XmlDocument.parse(response.body);
      print("extract sales data method ....");
      extractMDSales(document);
      setState(() {
        MDSales = response.body; // Update sales data
        isLoading = false; // Set loading state to false
      });
    } else {
      setState(() {
        MDSales = 'Failed to fetch sales data';
        isLoading = false; // Set loading state to false on failure
      });
    }
  }

  void extractMDSales(xml.XmlDocument document) {
    branchNames.clear(); // Clear previous branch data

    xml.XmlElement envelope = document.rootElement;
    Iterable<xml.XmlElement> bodyElements = envelope.findElements('soap:Body');
    print(bodyElements);
    if (bodyElements.isNotEmpty) {
      xml.XmlElement body = bodyElements.first;
      xml.XmlNode responseElement = body.children.first;

      // Parse the JSON response
      List<dynamic> branchesData = json.decode(responseElement.text);

      // Extract sales data for each branch
      for (var branchData in branchesData) {
        String branchName = branchData['BranchName'];
        branchNames.add(branchName);
        print(branchName);
        // Store sales data for the branch
        MDSalesByBranch[branchName] = branchData;
        // Add a flag to toggle chart visibility
        MDSalesByBranch[branchName]?['showChart'] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MDSalesByBranch = Map.fromEntries(MDSalesByBranch.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Report',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () {
                fetchData();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[800],
                backgroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8), // Adjust the border radius as needed
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24), // Adjust the padding as needed
                minimumSize: Size(double.infinity,
                    0), // Set minimum size to make the button fill the available space horizontally
                side: BorderSide(color: Colors.white, width: 1), // Add a border
              ),
              child: Text('Fetch Sales Report'),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator(), // Show circular progress indicator while loading
                  )
                : ListView.builder(
                    itemCount: branchNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      String branchName = branchNames[index];
                      Map<String, dynamic> MDSales =
                          MDSalesByBranch[branchName] ?? {};

                      return GestureDetector(
                        onTap: () {
                          // Handle tap on branch name to toggle visibility of chart
                          setState(() {
                            MDSalesByBranch[branchName]!['showChart'] =
                                !(MDSalesByBranch[branchName]!['showChart'] ??
                                    false);
                          });
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround, // Adjust as needed
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'April: ${MDSales['April'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'May: ${MDSales['May'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'June: ${MDSales['June'] ?? ''}'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround, // Adjust as needed
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'July: ${MDSales['July'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'August: ${MDSales['August'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'September: ${MDSales['September'] ?? ''}'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround, // Adjust as needed
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'October: ${MDSales['October'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'November: ${MDSales['November'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'December: ${MDSales['December'] ?? ''}'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround, // Adjust as needed
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'January: ${MDSales['January'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'February: ${MDSales['February'] ?? ''}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                                'March: ${MDSales['March'] ?? ''}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Handle tap on branch name to toggle visibility of chart
                                    setState(() {
                                      MDSalesByBranch[branchName]![
                                          'showChart'] = !(MDSalesByBranch[
                                              branchName]!['showChart'] ??
                                          false);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Branch Name: $branchName',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                if (MDSalesByBranch[branchName]?['showChart'] ??
                                    false)
                                  SizedBox(
                                    height: 300,
                                    child: BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        maxY: 4000000,
                                        barGroups: [
                                          BarChartGroupData(
                                            x: 4,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['April'] ?? '0'),
                                                color: Colors.red,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 5,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['May'] ?? '0'),
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 6,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['June'] ?? '0'),
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 7,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['JultoY'] ?? '0'),
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 8,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['August'] ?? '0'),
                                                color: Colors.purple,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 9,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['September'] ??
                                                        '0'),
                                                color: Colors.yellow,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 10,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['October'] ?? '0'),
                                                color: Colors.brown,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 11,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['November'] ?? '0'),
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 12,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['December'] ?? '0'),
                                                color: Colors.teal,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 1,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['January'] ?? '0'),
                                                color: Colors.cyan,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 2,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['February'] ?? '0'),
                                                color: Colors.indigo,
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 3,
                                            barRods: [
                                              BarChartRodData(
                                                toY: double.parse(
                                                    MDSales['March'] ?? '0'),
                                                color: Colors.lime,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
