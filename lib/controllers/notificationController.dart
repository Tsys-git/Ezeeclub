import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationController {
  Future<void> fetchNotification(memberNo, branchNo) async {
    final Uri url = Uri.parse(
        'http://oneabovefit.ezeeclub.net/MobileAppService.svc/getNotification');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> data = {
      "MemberNo": memberNo,
      "BranchNo": branchNo,
    };

    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          // Process the response here
          print(jsonResponse);
        } else {
          print('Empty response received');
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }
}
