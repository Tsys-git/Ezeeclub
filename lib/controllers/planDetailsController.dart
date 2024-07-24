import 'dart:convert';

import 'package:ezeeclub/consts/appConsts.dart';
import 'package:http/http.dart' as http;
import 'package:ezeeclub/models/Plan.dart'; // Import your Plan model

class Plandetailscontroller {
  Future<Plan> getPlanDetails(String memberNo, String branchNo) async {
    final Uri uri = Uri.parse("${AppConsts.url}/GetPlanDetails");
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> data = {
      "MemberNo": memberNo,
      "BranchNo": branchNo,
    };
    try {
      final http.Response response =
          await http.post(uri, headers: headers, body: json.encode(data));
      //print(response.body);

      if (response.statusCode == 200) {
        // Request was successful
        // Parse the response and return the Plan object
        final List<dynamic> responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          //print(responseData);
          final Map<String, dynamic> planData = responseData.first;
          print(planData);

          return Plan.fromJson(planData);
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
