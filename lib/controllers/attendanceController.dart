import 'dart:convert';
import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:http/http.dart' as http;

class AttendanceController {
  UrlSetting urlSetting = UrlSetting();

  Future<void> getAttendanceRewardsDetails(
      String memberNo, String branchNo) async {
    try {
      await urlSetting.initialize();

      // Use the URL from UrlSetting
      Uri? uri = urlSetting.getAttendanceRewards;

      final Map<String, String> headers = {"Content-Type": "application/json"};
      final Map<String, dynamic> data = {
        "MemberNo": memberNo,
        "BranchNo": branchNo,
      };

      final http.Response response = await http.post(
        uri!,
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

  Future<bool> saveAttendace(String MemberNo) async {
    try {
      await urlSetting.initialize();
      Uri? uri = urlSetting.saveAttendance;

      final Map<String, String> headers = {"Content-Type": "application/json"};
      final Map<String, String> data = {"MemberNo": MemberNo};

      final http.Response response =
          await http.post(uri!, headers: headers, body: json.encode(data));

      if (response.statusCode == 200) {
        print(' save attendance successfully');

        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return true;
      } else {
        return false;
        //throw Exception('Failed to save attendance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while save attendance: $e');
      rethrow;
    }
  }
}
