import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class MemberSearch extends StatefulWidget {
  final branchcount;
  const MemberSearch({super.key, this.branchcount});

  @override
  State<MemberSearch> createState() => _MemberSearchState();
}

class _MemberSearchState extends State<MemberSearch> {
  List<Map<String, String>> memberDetailsList =
      []; // List to hold member details
  bool isLoading = false;
  String? _selectedBranch;
  TextEditingController _branchController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredMemberDetailsList = [];
  String storedUrl = "";

  @override
  void initState() {
    super.initState();
    _branchController = TextEditingController();
    _searchController = TextEditingController();
    geturl();
  }

  void geturl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    storedUrl = prefs.getString('app_url')!;
    print('Current URL value: $storedUrl');
    _selectedBranch = '1'; // Initialize with default branch number or null
    fetchData(
        _selectedBranch!, storedUrl); // Fetch data for default branch initially
  }

  @override
  void dispose() {
    _branchController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String branchNo, String storedUrl) async {
    setState(() {
      isLoading = true;
    });

    String soapRequest = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <MemberDetails xmlns="http://tempuri.org/">
          <BranchNo>$branchNo</BranchNo>
        </MemberDetails>
      </soap:Body>
    </soap:Envelope>''';

    int contentLength = utf8.encode(soapRequest).length;

    try {
      http.Response response = await http.post(
        Uri.parse('http://$storedUrl/androidwebservice.asmx'),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tempuri.org/MemberDetails',
          'Content-Length': '$contentLength',
        },
        body: soapRequest,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        xml.XmlDocument document = xml.XmlDocument.parse(response.body);
        print(response.body);
        extractMemberDetails(document);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch member details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching member details: $e');
    }
  }

  void extractMemberDetails(xml.XmlDocument document) {
    List<Map<String, String>> detailsList = [];

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
        for (var member in responseList) {
          String memberNo = member['MemberNo'];
          String memberName = member['MemberName'];
          String memberNoBr = member['MemberNoBr'];

          Map<String, String> memberDetails = {
            'MemberNo': memberNo,
            'MemberName': memberName,
            'MemberNoBr': memberNoBr,
          };

          detailsList.add(memberDetails);
        }
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }

    setState(() {
      memberDetailsList = detailsList;
      // Initialize filteredMemberDetailsList with memberDetailsList
      filteredMemberDetailsList = List.from(memberDetailsList);
    });
  }

  void filterMemberList(String query) {
    List<Map<String, String>> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = memberDetailsList.where((member) {
        String memberName = member['MemberName'] ?? '';
        return memberName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      filteredList = List.from(memberDetailsList);
    }
    setState(() {
      filteredMemberDetailsList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems =
        List.generate(widget.branchcount, (index) {
      return DropdownMenuItem<String>(
        value: (index + 1).toString(),
        child: Text((index + 1).toString()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Member Search",
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MemberSearchDelegate(this),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : filteredMemberDetailsList.isEmpty
              ? Center(child: Text('No member details found'))
              : ListView.builder(
                  itemCount: filteredMemberDetailsList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Member No: ${filteredMemberDetailsList[index]['MemberNo']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Member Name: ${filteredMemberDetailsList[index]['MemberName']}',
                            ),
                            SizedBox(height: 5),
                            Text(
                              'MemberNoBr: ${filteredMemberDetailsList[index]['MemberNoBr']}',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: DropdownButtonFormField<String>(
          focusColor: Theme.of(context).primaryColor,
          iconEnabledColor: Theme.of(context).primaryColor,
          iconDisabledColor: Theme.of(context).primaryColor,
          value: _selectedBranch,
          onChanged: (value) {
            setState(() {
              _selectedBranch = value;
              fetchData(value!, storedUrl);
            });
          },
          items: dropdownItems,
          decoration: InputDecoration(
            labelText: 'Select Branch No',
            isCollapsed: false,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class MemberSearchDelegate extends SearchDelegate<String> {
  final _MemberSearchState _memberSearchState;

  MemberSearchDelegate(this._memberSearchState);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Enter a search query'));
    }

    List<Map<String, String>> filteredList = _memberSearchState
        .filteredMemberDetailsList
        .where((member) =>
            member['MemberName']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            filteredList[index]['MemberNoBr']!,
          ),
          title: Text(filteredList[index]['MemberName']!),
          subtitle: Text('Member No: ${filteredList[index]['MemberNo']}'),
          onTap: () {
            query = filteredList[index]['MemberName']!;
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    List<Map<String, String>> suggestionList = _memberSearchState
        .filteredMemberDetailsList
        .where((member) =>
            member['MemberName']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            suggestionList[index]['MemberNoBr']!,
          ),
          title: Text(suggestionList[index]['MemberName']!),
          subtitle: Text('Member No: ${suggestionList[index]['MemberNo']}'),
          onTap: () {
            query = suggestionList[index]['MemberName']!;

            print(_memberSearchState._selectedBranch!);
          },
        );
      },
    );
  }
}
