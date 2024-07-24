// Attendance_controller.dart

import 'dart:convert';
import 'package:ezeeclub/consts/appConsts.dart';
import 'package:http/http.dart' as http;

class AttendanceController {
  void getAttendanceRewardsDetails(String memberNo, String branchNo) async {
    Uri uri = Uri.parse("${AppConsts.url}/GetAttendanceRewards");
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, dynamic> data = {
      "MemberNo": memberNo,
      "BranchNo": branchNo,
    };

    try {
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
      } else {
        throw Exception(
            'Failed to load getAttendanceRewardsDetails: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching getAttendanceRewardsDetails: $e');
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }

  void fetchAttendanceData() async {
    print("calling fetch fetchAttendance data");
    // Construct SOAP request for MDConversion
    String conversionSoapRequest = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Attendance xmlns="http://tempuri.org/">
      <MobileNo></MobileNo>
      <MemberNo>6400</MemberNo>
      <BranchNo></BranchNo>
    </Attendance>
  </soap:Body>
</soap:Envelope>''';

    // Calculate length of SOAP request body
    int conversionContentLength = utf8.encode(conversionSoapRequest).length;

    // Make POST request with dynamic Content-Length header for MDConversion
    http.Response conversionResponse = await http.post(
      Uri.parse('http://janorkarsgym.ezeeclub.net/androidwebservice.asmx'),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/Attendance',
        'Content-Length': '$conversionContentLength',
      },
      body: conversionSoapRequest,
    );

    // Parse XML response for MDConversion and extract data
    if (conversionResponse.statusCode == 200) {
      print("Attendance Data response received.......");

      print(conversionResponse.body);
    }
  }
}
