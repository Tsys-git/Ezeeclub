import 'dart:convert';
import 'package:ezeeclub/models/dietplanmodel.dart';
import 'package:http/http.dart' as http;
import 'package:ezeeclub/consts/appConsts.dart';

class Dietplancontroller {
  Future<Dietplan?> getdietplan(String memberNo, String branchNo) async {
    Uri uri = Uri.parse("${AppConsts.url}/GetDiet");
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, String> data = {"MemberNo": memberNo, "BranchNo": branchNo};

    try {
      final http.Response response = await http.post(uri, headers: headers, body: json.encode(data));
      
      if (response.statusCode == 200) {
        // If the server returns a successful response
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          // If the response is a list, handle the first item (assuming it's the diet plan you need)
          if (jsonResponse.isNotEmpty) {
            return Dietplan.fromJson(jsonResponse[0]);
          } else {
            throw Exception('Empty response list');
          }
        } else if (jsonResponse is Map<String, dynamic>) {
          // If the response is a map (single object), parse it directly
          return Dietplan.fromJson(jsonResponse);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        // If the server returns an error response
        throw Exception('Failed to load diet plan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diet plan: $e');
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }
}
