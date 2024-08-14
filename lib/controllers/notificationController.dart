import 'dart:convert';

import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:ezeeclub/consts/userLogin.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  String memberNo = "";
  String branchNo = "";
  UrlSetting urlSetting = UrlSetting();
  Future<void> fetchNotification() async {
    urlSetting.initialize();
    memberNo = (await UserLogin().getMemberNo())!;
    branchNo = (await UserLogin().getBranchNo())!;
    try {
      final Uri? url = urlSetting.getNotification;
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final Map<String, dynamic> data = {
        "MemberNo": memberNo,
        "BranchNo": branchNo,
      };
      final http.Response response = await http.post(
        url!,
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
      print('Error during : $error');
    }
  }
}
