import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class MdEnquiry extends StatefulWidget {
  final String? brname;
  final String brno;

  const MdEnquiry({super.key, required this.brno, this.brname});

  @override
  State<MdEnquiry> createState() => _MdEnquiryState();
}

class EnquiryDetails {
  final String memberName;
  final String mobileNo;
  final String enquiryType;
  final String memberNo;

  EnquiryDetails({
    required this.enquiryType,
    required this.memberNo,
    required this.memberName,
    required this.mobileNo,
  });

  factory EnquiryDetails.fromJson(Map<String, dynamic> json) {
    return EnquiryDetails(
      enquiryType: json['EnquiryType'],
      memberNo: json['MemberNo'],
      memberName: json['Membername'],
      mobileNo: json['Mobileno'],
    );
  }
}

class _MdEnquiryState extends State<MdEnquiry> {
  String mdEnquiryStatus = 'Loading...';
  List<EnquiryDetails> enquiryList = [];
  List<EnquiryDetails> filteredList = [];
  late String storedUrl;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedUrl = prefs.getString('app_url') ?? '';
    print('Current URL value: $storedUrl');
    fetchData(storedUrl);
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = enquiryList
          .where((enquiry) => enquiry.mobileNo.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> fetchData(String storedUrl) async {
    String soapRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <EnquiryList xmlns="http://tempuri.org/">
      <Branchno>${widget.brno}</Branchno>
    </EnquiryList>
  </soap:Body>
</soap:Envelope>''';

    try {
      http.Response response = await http.post(
        Uri.parse('http://$storedUrl/androidwebservice.asmx'),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tempuri.org/EnquiryList',
        },
        body: soapRequest,
      );

      if (response.statusCode == 200) {
        xml.XmlDocument document = xml.XmlDocument.parse(response.body);
        extractEnquiryList(document);
      } else {
        setState(() {
          mdEnquiryStatus = 'Failed to fetch data';
        });
      }
    } catch (e) {
      setState(() {
        mdEnquiryStatus = 'Failed to fetch data: $e';
      });
    }
  }

  void extractEnquiryList(xml.XmlDocument document) {
    try {
      xml.XmlElement envelope = document.rootElement;
      Iterable<xml.XmlElement> bodyElements =
          envelope.findElements('soap:Body');

      if (bodyElements.isNotEmpty) {
        xml.XmlElement body = bodyElements.first;
        xml.XmlNode responseElement = body.children.first;

        List<dynamic> enquiryData = json.decode(responseElement.text);

        List<EnquiryDetails> newList =
            enquiryData.map((item) => EnquiryDetails.fromJson(item)).toList();

        setState(() {
          enquiryList = newList;
          filteredList = enquiryList;
          mdEnquiryStatus = '';
        });
      }
    } catch (e) {
      setState(() {
        mdEnquiryStatus = 'Failed to parse data';
      });
    }
  }

  void searchButtonPressed() {
    onSearchChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquiry List BR No: ${widget.brno}',
            style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by Mobile No...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                SizedBox(
                  width: 120.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: searchButtonPressed,
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (mdEnquiryStatus.isNotEmpty)
            Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )),
          if (filteredList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final enquiry = filteredList[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Member Name',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(enquiry.memberName,
                                style: TextStyle(color: Colors.black)),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.card_travel, color: Colors.black),
                            title: Text('Member No',
                                style: TextStyle(color: Colors.black)),
                            subtitle: Text(enquiry.memberNo,
                                style: TextStyle(color: Colors.black)),
                          ),
                          ListTile(
                            leading: Icon(Icons.call, color: Colors.black),
                            title: Text('Mobile No',
                                style: TextStyle(color: Colors.black)),
                            subtitle: Text(
                              enquiry.mobileNo,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.type_specimen, color: Colors.black),
                            title: Text('Enquiry Type',
                                style: TextStyle(color: Colors.black)),
                            subtitle: Text(
                              enquiry.enquiryType.isEmpty
                                  ? "Not mentioned"
                                  : enquiry.enquiryType,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (filteredList.isEmpty && mdEnquiryStatus.isEmpty)
            Center(
              child: Text('No data found.'),
            ),
        ],
      ),
    );
  }
}
