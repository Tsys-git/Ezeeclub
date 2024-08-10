import 'dart:convert';
import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:ezeeclub/consts/appConsts.dart';
import 'package:ezeeclub/models/PTSessionModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PTSessionController {
  UrlSetting urlSetting = UrlSetting();
  Future<List<PTSession>> getPTSessions(
      String memberNo, String branchNo) async {
    await urlSetting.initialize();
    Uri? uri = urlSetting.getPtSessions;

    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, String> params = {
      "MemberNo": memberNo,
      "BranchNo": branchNo,
    };

    try {
      final http.Response response =
          await http.post(uri!, headers: headers, body: json.encode(params));
      print(response);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        List<PTSession> sessions =
            jsonResponse.map((data) => PTSession.fromJson(data)).toList();
        print(sessions);
        return sessions;
      } else {
        throw Exception('Failed to load PT sessions');
      }
    } catch (e) {
      print('Error fetching PT sessions: $e');
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }
}
