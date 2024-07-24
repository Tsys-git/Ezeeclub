import 'dart:convert';

import 'package:ezeeclub/consts/appConsts.dart';
import 'package:ezeeclub/models/healthRecord.dart';
import "package:http/http.dart" as http;

class Healthdetailscontroller {
  Future<HealthDetail> getHealthDetails(memberNo, branchNo) async {
    final Uri uri = Uri.parse("${AppConsts.url}/GetHealthDetails");
    final Map<String, String> headers = {'Content-Type': 'Application/json'};
    final Map<String, String> data = {
      'MemberNo': memberNo,
      'BranchNo': branchNo,
    };
    try {
      final http.Response response =
          await http.post(uri, headers: headers, body: json.encode(data));
      if (response.statusCode == 200) {
        // Request was successful
        // Parse the response and return the Plan object
        final List<dynamic> responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          print(responseData);
          final Map<String, dynamic> HealthData = responseData.first;
          return HealthDetail.fromJson(HealthData);
        } else {
          throw Exception('Empty response received');
        }
      } else {
        // Request failed with an error status code
        // You can handle the error here
        throw Exception('Failed to fetch plan details: ${response.statusCode}');
      }
    } catch (e) {
      // Exception caught during the request
      // You can handle the exception here
      throw Exception('Failed to fetch plan details: $e');
    }
  }
}
