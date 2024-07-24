import 'dart:convert';

import 'package:ezeeclub/consts/appConsts.dart';
import 'package:ezeeclub/models/workout.dart';
import 'package:http/http.dart' as http;

class WorkoutDetailsController {
  Future<WorkoutDetails> getWorkoutDetails(
      String memberNo, String branchNo) async {
    final uri = Uri.parse("${AppConsts.url}/GetWorkOut");

    final Map<String, String> headers = {"Content-Type": "Application/json"};

    final Map<String, dynamic> data = {
      "MemberNo": memberNo,
      "BranchNo": branchNo
    };
    try {
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      print(response.body);
      print("hello world");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isNotEmpty) {
          final Map<String, dynamic> workoutData = responseData.first;
          print(workoutData);
          return WorkoutDetails.fromJson(workoutData);
        } else {
          throw Exception('Empty response received');
        }
      } else {
        throw Exception(
            'Failed to fetch workout details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }
}
