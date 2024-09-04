import 'dart:convert';

import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class DetailsReceipt extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String branchNo;
  final String branchName;

  const DetailsReceipt({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.branchNo,
    required this.branchName,
  });

  @override
  State<DetailsReceipt> createState() => _DetailsReceiptState();
}

class _DetailsReceiptState extends State<DetailsReceipt> {
  List<Map<String, dynamic>> salesDataList = [];
  bool isLoading = false;
  bool isAscending = true;
  Map<String, Map<String, dynamic>> categorizedAmounts = {};
  UrlSetting urlSetting = UrlSetting();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    await urlSetting.initialize();

    Uri? webserviceurl = urlSetting.webServiceUrl;

    String soapRequest = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <Sales xmlns="http://tempuri.org/">
          <BranchNo>${widget.branchNo}</BranchNo>
          <FromDate>${widget.startDate}</FromDate>
          <ToDate>${widget.endDate}</ToDate>
        </Sales>
      </soap:Body>
    </soap:Envelope>''';

    int contentLength = utf8.encode(soapRequest).length;

    try {
      http.Response response = await http.post(
        webserviceurl!,
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tempuri.org/Sales',
          'Content-Length': '$contentLength',
        },
        body: soapRequest,
      );

      if (response.statusCode == 200) {
        xml.XmlDocument document = xml.XmlDocument.parse(response.body);
        extractSalesData(document);
      } else {
        print('Failed to fetch sales data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sales data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void extractSalesData(xml.XmlDocument document) {
    List<Map<String, dynamic>> data = [];

    xml.XmlElement envelope = document.rootElement;
    Iterable<xml.XmlElement> bodyElements =
        envelope.findAllElements('soap:Body');
    if (bodyElements.isNotEmpty) {
      xml.XmlElement body = bodyElements.first;
      xml.XmlNode responseElement = body.children.first;

      String jsonResponse = responseElement.text;
      print('Raw JSON Response: $jsonResponse');

      try {
        List<dynamic> responseList = json.decode(jsonResponse);

        for (var sale in responseList) {
          String type = sale['Type'];
          String receiptNo = sale['ReceiptNo'];
          String receiptDate = sale['ReceiptDate'];
          String memberName = sale['MemberName'];
          String counselor = sale['Counseller'];
          String planName = sale['PlanName'];
          String programName = sale['ProgramName'];
          String amount = sale['Amount'];
          String status = sale['Status'];
          String remark = sale['Remark'];
          String createdOn = sale['CreatedOn'];

          Map<String, dynamic> saleDetails = {
            'Type': type,
            'ReceiptNo': receiptNo,
            'ReceiptDate': receiptDate,
            'MemberName': memberName,
            'Counselor': counselor,
            'PlanName': planName,
            'ProgramName': programName,
            'Amount': amount,
            'Status': status,
            'Remark': remark,
            'CreatedOn': createdOn,
          };

          data.add(saleDetails);
        }

        sortSalesData(data);
        findUniqueRemarksAndSumAmounts(data);
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }

    setState(() {
      salesDataList = data;
    });
  }

  void sortSalesData(List<Map<String, dynamic>> data) {
    data.sort((a, b) {
      String dateA = a['ReceiptDate'];
      String dateB = b['ReceiptDate'];
      return isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
  }

  void findUniqueRemarksAndSumAmounts(List<Map<String, dynamic>> data) {
    double grandTotal = 0.0;

    categorizedAmounts = {
      'GPay': {'amount': 0.0, 'image': 'assets/payment/gpay.png'},
      'Credit Card': {'amount': 0.0, 'image': 'assets/payment/cc.png'},
      'Cash': {'amount': 0.0, 'image': 'assets/payment/cash.png'},
      'Other': {'amount': 0.0, 'image': 'assets/payment/others.png'},
    };

    for (var sale in data) {
      String remark = sale['Remark'].toLowerCase();
      double amount = double.parse(sale['Amount']);

      if (remark.contains('cash')) {
        categorizedAmounts['Cash']!['amount'] += amount;
      } else if (remark.contains('cc') ||
          remark.contains('credit') ||
          remark.contains('card')) {
        categorizedAmounts['Credit Card']!['amount'] += amount;
      } else if (remark.contains('upi') ||
          remark.contains('gpay') ||
          remark.contains('GPAY') ||
          remark.contains('phonepe') ||
          remark.contains('phone pay')) {
        categorizedAmounts['GPay']!['amount'] += amount;
      } else {
        categorizedAmounts['Other']!['amount'] += amount;
      }

      grandTotal += amount;
    }

    // Print categorized amounts and grand total
    categorizedAmounts.forEach((category, details) {
      print('Category: $category, Sum of Amounts: ${details['amount']}');
    });

    print('Grand Total: $grandTotal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isAscending = !isAscending;
                sortSalesData(salesDataList);
              });
            },
            icon: !isAscending
                ? Icon(Icons.sort, color: Colors.amber, size: 32)
                : Icon(Icons.sort_rounded, color: Colors.white),
          ),
        ],
        title: Text(widget.branchName, style: TextStyle(fontSize: 18)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : salesDataList.isEmpty
              ? Center(child: Text('No sales data found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     SizedBox(
  height: MediaQuery.of(context).size.height * 0.2,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: categorizedAmounts.length,
    itemBuilder: (context, index) {
      String category = categorizedAmounts.keys.elementAt(index);
      double amount = categorizedAmounts[category]!['amount'];
      String imagePath = categorizedAmounts[category]!['image'];

      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 6),
                Text(
                  category,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10),
                ),
                SizedBox(height: 6),
                Text(
                  '${amount.toStringAsFixed(0)} RS/-',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),

                      SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1,
                        child: ListView.builder(
                          itemCount: salesDataList.length,
                          itemBuilder: (context, index) {
                            return buildReceiptCard(salesDataList[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget buildReceiptCard(Map<String, dynamic> receiptData) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receipt No:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(receiptData['ReceiptNo'],style: TextStyle(fontSize: 10)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receipt Date:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(receiptData['ReceiptDate'],style: TextStyle(fontSize: 10)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('Member Name:',
                      style: TextStyle(fontWeight: FontWeight.bold,)),
                ),
            
                Text(receiptData['MemberName'],style: TextStyle(fontSize: 10)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Counselor:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(receiptData['Counselor'],style: TextStyle(fontSize: 10)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Plan Name:',
                    style: TextStyle(fontWeight: FontWeight.bold,)),
                Text(receiptData['PlanName'],style: TextStyle(fontSize: 10),),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('Program Name:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Flexible(child: Text(receiptData['ProgramName'],style: TextStyle(fontSize: 10)),),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(receiptData['Amount'],style: TextStyle(fontSize: 10)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Remark:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    receiptData['Remark'],
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
