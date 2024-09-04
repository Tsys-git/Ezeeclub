import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SoapRequestDemo extends StatefulWidget {
  const SoapRequestDemo({super.key});

  @override
  _SoapRequestDemoState createState() => _SoapRequestDemoState();
}

class _SoapRequestDemoState extends State<SoapRequestDemo> {
  String _response = 'Response will be shown here';

  Future<void> sendSoapRequest() async {
    const String soapRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <PendingJobCard xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>''';

    final response = await http.post(
      Uri.parse('https://sreetrans.tsysinfo.in/WebService.asmx'),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/PendingJobCard',
      },
      body: utf8.encode(soapRequest),
    );

    if (response.statusCode == 200) {
      setState(() {
        _response = response.body;
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("soap"),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: sendSoapRequest,
            child: Text('Send SOAP Request'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Text(_response),
            ),
          ),
        ],
      ),
    );
  }
}
