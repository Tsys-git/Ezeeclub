import 'dart:convert';
import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:http/http.dart' as http;

import '../models/measurement.dart';

class MeasurementController {
  UrlSetting urlSetting = UrlSetting();

  Future<List<Measurement>> getMeasurementDetails(
      String memberNo, String branchNo) async {
    try {
      await urlSetting.initialize();

      // Use the URL from UrlSetting
      Uri? uri = urlSetting.getMeasureDetails;

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
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData.map((data) => Measurement.fromJson(data)).toList();
      } else {
        throw Exception(
            'Failed to load getMeasurementDetails: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching getMeasurementDetails: $e');
      rethrow;
    }
  }
}
