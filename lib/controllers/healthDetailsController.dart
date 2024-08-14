import 'dart:convert';
import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:ezeeclub/models/healthRecord.dart';
import "package:http/http.dart" as http;

class Healthdetailscontroller {
  final UrlSetting urlSetting =
      UrlSetting(); // Create an instance of UrlSetting

  Future<HealthDetail?> getHealthDetails(
      String memberNo, String branchNo) async {
    try {
      // Ensure that URLSetting is initialized
      await urlSetting.initialize();

      // Use the URL from UrlSetting
      Uri? uri =
          urlSetting.getHealthDetails; // Use the URL method from UrlSetting

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final Map<String, String> data = {
        'MemberNo': memberNo,
        'BranchNo': branchNo,
      };

      print('Making request to: $uri');

      final http.Response response = await http.post(
        uri!,
        headers: headers,
        body: json.encode(data),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Request was successful
        final List<dynamic> responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          print(responseData);
          final Map<String, dynamic> healthData = responseData.first;
          return HealthDetail.fromJson(healthData);
        } else {
          throw Exception('Empty response received');
        }
      } else {
        throw Exception(
            'Failed to fetch health details: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Exception caught during the request
      print('Error fetching health details: $e');
      throw Exception('Failed to fetch health details: $e');
    }
  }
}
