import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:fl_chart/fl_chart.dart';

class MDRecieptScreen extends StatefulWidget {
  const MDRecieptScreen({super.key});

  @override
  _MDRecieptScreenState createState() => _MDRecieptScreenState();
}

class _MDRecieptScreenState extends State<MDRecieptScreen> {
  String MDRecieptStatus = 'Loading...'; // Placeholder for sales data
  List<String> branchNames = []; // List to store branch names
  Map<String, Map<String, dynamic>> MDRecieptStatusByBranch =
      {}; // Map to store sales data by branch

  TextEditingController _branchController = TextEditingController();
  bool isLoading = false; // Loading indicator state

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch sales data when the screen initializes
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading state true when fetching starts
    });

    // Construct SOAP request
    String soapRequest = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MDReceipt xmlns="http://tempuri.org/">
      <BranchNo>1</BranchNo>
    </MDReceipt>
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
      extractMDRecieptStatus(document);
      setState(() {
        MDRecieptStatus = response
            .body; // Change to display entire response body for debugging
        isLoading = false; // Set loading state false after data is fetched
      });
    } else {
      setState(() {
        MDRecieptStatus = 'Failed to fetch sales data';
        isLoading = false; // Set loading state false if fetching fails
      });
    }
  }

  void extractMDRecieptStatus(xml.XmlDocument document) {
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
        MDRecieptStatusByBranch[branchName] = branchData;
        // Add a flag to toggle chart visibility
        MDRecieptStatusByBranch[branchName]?['showChart'] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MD Receipt',
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
                backgroundColor: Colors.white,
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
              child: Text('Fetch MD Receipt'),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator while fetching data
                : ListView.builder(
                    itemCount: branchNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      String branchName = branchNames[index];
                      Map<String, dynamic> MDRecieptStatus =
                          MDRecieptStatusByBranch[branchName] ?? {};

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle tap on branch name to toggle visibility of chart
                                  setState(() {
                                    MDRecieptStatusByBranch[branchName]![
                                            'showChart'] =
                                        !(MDRecieptStatusByBranch[branchName]![
                                                'showChart'] ??
                                            false);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Branch Name: $branchName',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              if (MDRecieptStatusByBranch[branchName]
                                  ?['showChart'])
                                SizedBox(
                                  height: 300,
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceBetween,
                                      maxY: 4000000,
                                      barGroups: [
                                        BarChartGroupData(
                                          x: 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['January'] ??
                                                      '0'),
                                              color: Colors.cyan,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 2,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['February'] ??
                                                      '0'),
                                              color: Colors.indigo,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 3,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['March'] ??
                                                      '0'),
                                              color: Colors.lime,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 4,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['April'] ??
                                                      'hello'),
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 5,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['May'] ??
                                                      '0'),
                                              color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 6,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['June'] ??
                                                      '0'),
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 7,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['JultoY'] ??
                                                      '0'),
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 8,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['August'] ??
                                                      '0'),
                                              color: Colors.purple,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 9,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(MDRecieptStatus[
                                                      'September'] ??
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
                                                  MDRecieptStatus['October'] ??
                                                      '0'),
                                              color: Colors.brown,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 11,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['November'] ??
                                                      '0'),
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 12,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  MDRecieptStatus['December'] ??
                                                      '0'),
                                              color: Colors.teal,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
