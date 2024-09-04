import 'dart:convert';

import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class MDDailyStatusScreen extends StatefulWidget {
  const MDDailyStatusScreen({super.key});

  @override
  _MDDailyStatusScreenState createState() => _MDDailyStatusScreenState();
}

class _MDDailyStatusScreenState extends State<MDDailyStatusScreen> {
  String MDDailyStatus = 'Loading...'; // Placeholder for sales data
  List<String> branchNames = []; // List to store branch names
  Map<String, Map<String, dynamic>> MDDailyStatusByBranch =
      {}; // Map to store sales data by branch

  String storedUrl = "";
  UrlSetting urlSetting = UrlSetting();
  TextEditingController _branchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    geturl();
  }

  void geturl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    storedUrl = prefs.getString('app_url')!;
    print('Current URL value: $storedUrl');

    fetchData();
  }

  Future<void> fetchData() async {
    await urlSetting.initialize();

    // Use the URL from UrlSetting
    Uri? mddaily = urlSetting.MDDailyStatus;
    Uri? webserviceurl = urlSetting.webServiceUrl;
    print("calling fetch data");
    // Construct SOAP request
    String soapRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MDDailyStatus xmlns="http://tempuri.org/">
      <BranchNo>1</BranchNo>
    </MDDailyStatus>
  </soap:Body>
</soap:Envelope>''';

    // Calculate length of SOAP request body
    int contentLength = utf8.encode(soapRequest).length;

    // Make POST request with dynamic Content-Length header
    http.Response response = await http.post(
      webserviceurl!,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/$mddaily',
        'Content-Length': '$contentLength', // Set dynamic Content-Length
      },
      body: soapRequest,
    );

    // Parse XML response and extract branch names and sales
    if (response.statusCode == 200) {
      print(response.body);
      xml.XmlDocument document = xml.XmlDocument.parse(response.body);
      print("extract sales data method ....");
      extractMDDailyStatus(document);
      setState(() {
        MDDailyStatus = response
            .body; // Change to display entire response body for debugging
      });
    } else {
      setState(() {
        MDDailyStatus = 'Failed to fetch sales data';
      });
    }
  }

  void extractMDDailyStatus(xml.XmlDocument document) {
    branchNames.clear(); // Clear previous branch data
    MDDailyStatusByBranch.clear(); // Clear previous sales data

    xml.XmlElement envelope = document.rootElement;
    Iterable<xml.XmlElement> bodyElements = envelope.findElements('soap:Body');
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
        MDDailyStatusByBranch[branchName] = branchData;
        // Print sales data for the branch
        print('Sales data for $branchName:');
        print('Enquiry: ${branchData['Enquiry']}');
        print('Current Conversion: ${branchData['CurrentConv']}');
        print('Previous Conversion: ${branchData['PrevConv']}');
        print('Sale Amount: ${branchData['SaleAmount']}');
        print('Balance Amount: ${branchData['BalanceAmount']}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Status',
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
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
              child: Text('Fetch Daily Status'),
            ),
          ),
          Expanded(
            child: MDDailyStatus == "Loading..."
                ? Center(
                    child: Text("Click above button to fetch the data",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0),
                    itemCount: branchNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      String branchName = branchNames[index];
                      Map<String, dynamic> MDDailyStatus =
                          MDDailyStatusByBranch[branchName] ?? {};

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyStatusDetails(
                                  branchName: branchName,
                                  DailyStatus: MDDailyStatus,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Color.fromARGB(70, 65, 168, 228),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Center(
                                      child: Text(
                                        branchName.replaceAll("One Above", ""),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
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

class DailyStatusDetails extends StatelessWidget {
  final String branchName;
  final Map<String, dynamic> DailyStatus;
  const DailyStatusDetails({
    super.key,
    required this.branchName,
    required this.DailyStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(branchName, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                " Today's Date : ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text("Branch Name", style: TextStyle(color: Colors.white)),
              subtitle: Text(branchName, style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.home,
                size: 24,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text("Enquiry", style: TextStyle(color: Colors.white)),
              subtitle: Text(DailyStatus['Enquiry'],
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.question_answer,
                size: 24,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text("Receipt", style: TextStyle(color: Colors.white)),
              subtitle: Text(DailyStatus['Receipt'],
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.receipt_long,
                size: 24,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text("Cash Amount", style: TextStyle(color: Colors.white)),
              subtitle: Text(DailyStatus['CashAmount'],
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.currency_rupee,
                size: 24,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text("Cheque Amount", style: TextStyle(color: Colors.white)),
              subtitle: Text(DailyStatus['ChequeAmount'],
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.currency_rupee_outlined,
                size: 24,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text("Expiry", style: TextStyle(color: Colors.white)),
              subtitle: Text(DailyStatus['Expiry'],
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.edit_note_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text("Renew", style: TextStyle(color: Colors.white)),
              subtitle: Text(DailyStatus['Renew'],
                  style: TextStyle(color: Colors.grey)),
              leading: Icon(
                Icons.new_label,
                size: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
