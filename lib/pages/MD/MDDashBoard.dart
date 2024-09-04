import 'dart:convert';

import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:ezeeclub/consts/userLogin.dart';
import 'package:ezeeclub/pages/Auth/login.dart';
import 'package:ezeeclub/pages/MD/MDConversion.dart';
import 'package:ezeeclub/pages/MD/MDDailyStatus.dart';
import 'package:ezeeclub/pages/MD/MDUserSearch.dart';
import 'package:ezeeclub/pages/MD/dashboard.dart';
import 'package:ezeeclub/pages/MD/sub/Enquiry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import 'sub/monthWiseSales.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _conversionData = 'Loading...';
  String _salesData = 'Loading...';
  Color? cardcolor;
  String name = "Loading...";
  int branches = 0;

  UrlSetting urlSetting = UrlSetting();
  List<String> _branchNames = [];
  Map<String, Map<String, dynamic>> _conversionDataByBranch = {};
  Map<String, Map<String, dynamic>> _salesDataByBranch = {};
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
    getUserName();
  }

  void getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('mdname')!;
    print(name);

    fetchConversionData();
    fetchSalesData();
  }

  void _scrollListener() {
    setState(() {
      // Check if the offset is greater than 0
      // If yes, change the color to Colors.red; otherwise, keep it as Colors.grey[900]
      if (_controller.offset > 0) {
        cardcolor = Colors.grey[900]!;
      } else {
        // cardcolor = Color.fromARGB(24, 199, 28, 28);
        cardcolor = Colors.grey[900]!;
      }
    });
  }

  Future<void> fetchConversionData() async {
    print("calling fetch conversion data");
    // Construct SOAP request for MDConversion
    String conversionSoapRequest = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MDConversion xmlns="http://tempuri.org/">
      <BranchNo>1</BranchNo>
    </MDConversion>
  </soap:Body>
</soap:Envelope>''';

    // Calculate length of SOAP request body
    int conversionContentLength = utf8.encode(conversionSoapRequest).length;
    await urlSetting.initialize();

    // Use the URL from UrlSetting
    Uri? mdconv = urlSetting.MDConversion;
    Uri? webserviceurl = urlSetting.webServiceUrl;
    // Make POST request with dynamic Content-Length header for MDConversion
    http.Response conversionResponse = await http.post(
      webserviceurl!,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/$mdconv',
        'Content-Length': '$conversionContentLength',
      },
      body: conversionSoapRequest,
    );

    // Parse XML response for MDConversion and extract data
    if (conversionResponse.statusCode == 200) {
      print("MDConversion response received.......");

      print(conversionResponse.body);

      xml.XmlDocument conversionDocument =
          xml.XmlDocument.parse(conversionResponse.body);

      print("Extracting MDConversion data....");
      extractConversionData(conversionDocument);

      // Update UI with MDConversion data
      setState(() {
        _conversionData = ''; // Clear placeholder text
      });
    } else {
      setState(() {
        _conversionData = 'Failed to fetch conversion data';
      });
    }
  }

  Future<void> fetchSalesData() async {
    await urlSetting.initialize();

    // Use the URL from UrlSetting
    Uri? mdsales = urlSetting.MDSales;
    Uri? webserviceurl = urlSetting.webServiceUrl;
    print("calling fetch sales data");
    // Construct SOAP request for MDSales
    String salesSoapRequest = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MDSales xmlns="http://tempuri.org/">
      <BranchNo>1</BranchNo>
    </MDSales>
  </soap:Body>
</soap:Envelope>''';

    // Calculate length of SOAP request body
    int salesContentLength = utf8.encode(salesSoapRequest).length;

    // Make POST request with dynamic Content-Length header for MDSales
    http.Response salesResponse = await http.post(
      webserviceurl!,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/$mdsales',
        'Content-Length': '$salesContentLength',
      },
      body: salesSoapRequest,
    );

    // Parse XML response for MDSales and extract data
    if (salesResponse.statusCode == 200) {
      print("MDSales response received.......${salesResponse.body}");

      print(salesResponse.body);
      xml.XmlDocument salesDocument = xml.XmlDocument.parse(salesResponse.body);
      print("Extracting MDSales data....");
      extractSalesData(salesDocument);

      // Update UI with MDSales data
      setState(() {
        _salesData = ''; // Clear placeholder text
      });
    } else {
      setState(() {
        _salesData = 'Failed to fetch sales data';
      });
    }
  }

  void extractConversionData(xml.XmlDocument document) {
    _branchNames.clear();
    _conversionDataByBranch.clear();

    xml.XmlElement envelope = document.rootElement;
    Iterable<xml.XmlElement> bodyElements = envelope.findElements('soap:Body');

    if (bodyElements.isNotEmpty) {
      xml.XmlElement body = bodyElements.first;
      xml.XmlNode responseElement = body.children.first;

      List<dynamic> conversionData = json.decode(responseElement.text);

      for (var data in conversionData) {
        String branchName = data['BranchName'];
        _branchNames.add(branchName);
        _conversionDataByBranch[branchName] = data;
      }

      setState(() {
        branches = _branchNames.length;
      });
    }
  }

  void extractSalesData(xml.XmlDocument document) {
    _branchNames.clear();
    _salesDataByBranch.clear();

    xml.XmlElement envelope = document.rootElement;
    Iterable<xml.XmlElement> bodyElements = envelope.findElements('soap:Body');

    if (bodyElements.isNotEmpty) {
      xml.XmlElement body = bodyElements.first;
      xml.XmlNode responseElement = body.children.first;

      List<dynamic> salesData = json.decode(responseElement.text);

      for (var data in salesData) {
        String branchName = data['BranchName'];
        _branchNames.add(branchName);
        _salesDataByBranch[branchName] = data;
      }
    }
  }

  final List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String _selectedmonth = "January";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            'Dashboard',
            style: TextStyle(
               fontSize: 12,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          UserLogin().logout();
                          Get.offAll(() => LoginScreen());
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              fetchConversionData();
              fetchSalesData();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Container(
              padding: EdgeInsets.all(2),
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Summary",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text('Slide to right for more details'),
                      //         behavior: SnackBarBehavior.floating,
                      //         margin: EdgeInsets.only(right: 50, bottom: 600),
                      //       ),
                      //     );
                      //   },
                      //   icon: Icon(Icons.info),
                      // ),
                    ],
                  ),
                  Card(
                    color: Color.fromARGB(70, 65, 168, 228),
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Branch\nName',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: _buildDataRows(),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            child: Card(
                              color: cardcolor,
                              child: DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      "Enquiry",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Current\nConv",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Prev\nConv",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Sale\nAmt.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Balance\nAmt.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: builddynamirows(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          "Monthly Sales Summary",
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                        focusColor: Colors.red,
                        dropdownColor: Colors.white,
                        value: _selectedmonth,
                        decoration: InputDecoration(
                          labelText: 'Select Month',
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color.fromARGB(20, 111, 16, 16),
                              )),
                        ),
                        items: monthNames.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedmonth = value!;
                            print(_selectedmonth);
                            _buildSalesDataRows(_selectedmonth);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Color.fromARGB(70, 65, 168, 228),
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                'Branch Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                _selectedmonth,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                            rows: _buildSalesDataRows(_selectedmonth),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      padding: EdgeInsets.all(1),
                      children: [
                        DashboardOption(
                          img: 'assets/md/reciept.png',

                          title: 'Daily Status',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MDDailyStatusScreen())),
                        ),
                        DashboardOption(
                          img: 'assets/md/user.png',
                          title: 'Member',
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MemberSearch(branchcount: branches))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    List<DataRow> rows = [];

    for (var branchName in _branchNames) {
      if (_conversionDataByBranch.containsKey(branchName)) {
        var data = _conversionDataByBranch[branchName]!;
        rows.add(DataRow(
          cells: [
            DataCell(GestureDetector(
              onTap: () {
                Get.to(
                  () => DetailsPage(branchName: branchName, MDConversion: data),
                );
              },
              child: Text(
                
                branchName.replaceAll("One Above", ""),
                style: TextStyle(color: Colors.white, fontSize: 12,height: 1),
              ),
            )),
          ],
        ));
      }
    }

    return rows;
  }

  List<DataRow> builddynamirows() {
    List<DataRow> rows = [];

    for (var branchName in _branchNames) {
      if (_conversionDataByBranch.containsKey(branchName)) {
        var data = _conversionDataByBranch[branchName]!;
        rows.add(DataRow(
          cells: [
            DataCell(
              GestureDetector(
                  onTap: () {
                    Get.to(() => MdEnquiry(
                          brno: data['BranchNo'].toString(),
                          brname: data['BranchName'].toString(),
                        ));
                  },
                  child: Text(data['Enquiry'],
                      style: TextStyle(color: Colors.white))),
            ),
            DataCell(Text(data['CurrentConv'],
                style: TextStyle(color: Colors.white))),
            DataCell(
                Text(data['PrevConv'], style: TextStyle(color: Colors.white))),
            DataCell(Text(data['SaleAmount'],
                style: TextStyle(color: Colors.white))),
            DataCell(Text(data['BalanceAmount'],
                style: TextStyle(color: Colors.white))),
          ],
        ));
      }
    }

    return rows;
  }

  List<DataRow> _buildSalesDataRows(String selectedMonth) {
    List<DataRow> rows = [];

    for (var branchName in _branchNames) {
      if (_salesDataByBranch.containsKey(branchName)) {
        var data = _salesDataByBranch[branchName]!;
        var mdconvdata = _conversionDataByBranch[branchName];

        // Get the sales data for the selected month
        var salesForMonth = data[selectedMonth];

        // If data for the selected month exists
        if (salesForMonth != null) {
          rows.add(DataRow(
            cells: [
              DataCell(
                GestureDetector(
                  onTap: () {
                    // Navigate to detailed sales page for this branch and month
                    Get.to(() => SalesMonthWise(
                          dataSales: data,
                          BranchNo: mdconvdata?['BranchNo'],
                          BrancName: branchName,
                        ))?.then((value) {
                      // Handle any state changes needed after returning from SalesMonthWise
                      // Typically, you would update state here if necessary
                      setState(() {
                        selectedMonth = selectedMonth;
                        print(salesForMonth.toString());
                      });
                    });
                  },
                  child: SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        branchName.replaceAll("One Above", ""),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // Display sales data for the selected month only
              DataCell(Text(
                salesForMonth.toString(),
                style: TextStyle(color: Colors.white),
              )),
            ],
          ));
        }
      }
    }
    return rows;
  }
}
