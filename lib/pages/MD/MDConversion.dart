import 'dart:convert';

import 'package:ezeeclub/pages/MD/sub/Enquiry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:pie_chart/pie_chart.dart';

class MDConversionScreen extends StatefulWidget {
  const MDConversionScreen({super.key});

  @override
  _MDConversionScreenState createState() => _MDConversionScreenState();
}

class _MDConversionScreenState extends State<MDConversionScreen> {
  String MDConversion = 'Loading...'; // Placeholder for sales data
  List<String> branchNames = []; // List to store branch names
  Map<String, Map<String, dynamic>> MDConversionByBranch =
      {}; // Map to store sales data by branch

  TextEditingController _branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print("calling fetch data");
    // Construct SOAP request
    String soapRequest = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MDConversion xmlns="http://tempuri.org/">
      <BranchNo>1</BranchNo>
    </MDConversion>
  </soap:Body>
</soap:Envelope>''';

    // Calculate length of SOAP request body
    int contentLength = utf8.encode(soapRequest).length;

    // Make POST request with dynamic Content-Length header
    http.Response response = await http.post(
      Uri.parse('http://oneabovefit.ezeeclub.net/androidwebservice.asmx'),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/MDConversion',
        'Content-Length': '$contentLength', // Set dynamic Content-Length
      },
      body: soapRequest,
    );

    // Parse XML response and extract branch names and sales
    if (response.statusCode == 200) {
      print("response recieved.......");

      print(response.body);
      xml.XmlDocument document = xml.XmlDocument.parse(response.body);
      print("extract sales data method ....");
      extractMDConversion(document);

      // Update UI with sales data
      setState(() {
        MDConversion = ''; // Clear placeholder text
      });
    } else {
      setState(() {
        MDConversion = 'Failed to fetch sales data';
      });
    }
  }

  void extractMDConversion(xml.XmlDocument document) {
    branchNames.clear(); // Clear previous branch data
    MDConversionByBranch.clear(); // Clear previous sales data

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
        MDConversionByBranch[branchName] = branchData;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MD Conversion',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
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
              child: Text('Fetch MD Conversion Data'),
            ),
          ),
          Expanded(
            child: MDConversion == 'Loading...'
                ? Center(
                    child: Text("Click above button to fetch the data",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: branchNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      String branchName = branchNames[index];
                      Map<String, dynamic> MDConversion =
                          MDConversionByBranch[branchName] ?? {};

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                branchName: branchName,
                                MDConversion: MDConversion,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(
                                    10), // Different radius for bottom left
                                bottomRight: Radius.circular(
                                    10), // Different radius for bottom right
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    // ${MDConversion['BranchNo']}\n
                                    branchName.replaceAll("One Above", ""),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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

class DetailsPage extends StatelessWidget {
  final String branchName;
  final Map<String, dynamic> MDConversion;

  const DetailsPage({
    super.key,
    required this.branchName,
    required this.MDConversion,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare data for pie chart
    Map<String, double> dataMap = {
      'Sales Amount': double.parse(MDConversion['SaleAmount'] ?? '0'),
      'Balance Amount': double.parse(MDConversion['BalanceAmount'] ?? '0'),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          MDConversion['BranchName'],
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text(
                  'Branch Name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  branchName ?? "NA",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => MdEnquiry(
                        brno: MDConversion['BranchNo'].toString(),
                        brname: branchName,
                      ));
                },
                child: ListTile(
                  leading: Icon(Icons.question_answer, color: Colors.white),
                  title: Text(
                    'Enquiry',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    MDConversion['Enquiry'] ?? "NA",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.forward, color: Colors.white),
                title: Text(
                  'Current Conversion',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  MDConversion['CurrentConv'] ?? "NA",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              ListTile(
                leading: Icon(Icons.double_arrow, color: Colors.white),
                title: Text(
                  'Previous Conversion',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  MDConversion['PrevConv'] ?? "NA",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_box, color: Colors.white),
                title: Text(
                  'Sale Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  MDConversion['SaleAmount'] ?? "NA",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance, color: Colors.white),
                title: Text(
                  'Balance Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  MDConversion['BalanceAmount'] ?? "NA",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              Divider(
                height: 3,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 3000),
                    chartLegendSpacing: 16,
                    chartRadius: MediaQuery.of(context).size.width / 1.5,
                    colorList: [Colors.red[300]!, Colors.green[300]!],
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                    ringStrokeWidth: 2,
                    centerText: "Sales vs Balance",
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.top,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: true,
                      decimalPlaces: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
