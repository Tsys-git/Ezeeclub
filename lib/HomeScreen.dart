import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class SoapButton extends StatefulWidget {
  @override
  _SoapButtonState createState() => _SoapButtonState();
}

class _SoapButtonState extends State<SoapButton> {
  String _response = '';

  Future<void> _makeRequest() async {
    final soapService =
        SoapService('https://sreetrans.tsysinfo.in/WebService.asmx');
    final response = await soapService.makeSoapRequest();
    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _makeRequest,
            child: Text('Make SOAP Request'),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  _response,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SoapService {
  final String url;

  SoapService(this.url);

  Future<String> makeSoapRequest() async {
    // Construct the SOAP request body
    final soapRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <PendingJobCard xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>''';

    // Send the HTTP POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/PendingJobCard',
      },
      body: soapRequest,
    );
    print(response.reasonPhrase);
    if (response.statusCode == 200) {
      print("response :${response.body}"); // Return the response as a string
      return response.body;
    } else {
      // Return an error message
      return 'Request failed with status: ${response.statusCode}.';
    }
  }
}
