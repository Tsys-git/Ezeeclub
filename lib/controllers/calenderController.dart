import 'dart:convert';
import 'package:ezeeclub/models/calender.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CalendarController {
  Future<Uri> _getStoredUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUrl = prefs.getString('app_url');
    return Uri.parse(storedUrl ?? "");
  }

  Future<List<CalendarEvent>> getCalendarDetails(
      String memberNo, String branchNo, String month, String year) async {
    Uri uri = (await _getStoredUrl()).resolve("/GetCalendarDetails");
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, dynamic> data = {
      "MemberNo": memberNo,
      "BranchNo": branchNo,
      "Month": month,
      "Year": year,
    };

    try {
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          return jsonResponse.map((e) => CalendarEvent.fromJson(e)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to load calendar events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching calendar events: $e');
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }
}
