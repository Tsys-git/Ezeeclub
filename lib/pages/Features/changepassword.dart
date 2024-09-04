import 'dart:convert';
import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:ezeeclub/consts/userLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class changepassword extends StatefulWidget {
  const changepassword({super.key});

  @override
  _changepasswordState createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  UrlSetting urlSetting = UrlSetting();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String MemberNo = "";
  String BranchNo = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMemberNo();
  }

  Future<void> _loadMemberNo() async {
    UserLogin userLogin = UserLogin();
    String? memeberno = await userLogin.getMemberNo();
    String? branchno = await userLogin.getBranchNo();

    setState(() {
      MemberNo = memeberno ?? "";
      BranchNo = branchno ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: oldPassword,
              obscureText: false, // Password fields should be obscured
              decoration: InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: newPassword,
              obscureText: false, // Password fields should be obscured
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: confirmPassword,
              obscureText: false, // Password fields should be obscured
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: ElevatedButton(
                onPressed: () {
                  if (newPassword.text != confirmPassword.text) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'New password and confirm password do not match',
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  } else {
                    checkOldPassword(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Reset Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkOldPassword(BuildContext context) async {
    final Uri url = Uri.parse(
        'http://oneabovefit.ezeeclub.net/MobileAppService.svc/UserLogin');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> data = {
      'UserName': MemberNo,
      'Password': oldPassword.text,
    };

    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);

        if (jsonResponse != null) {
          // Add logic to reset the password
          print('Old password is correct, proceed to reset the password.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Old password is correct, proceed to reset the password.',
              style: TextStyle(color: Colors.white),
            ),
          ));

          changePassword(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Old password is incorrect',
              style: TextStyle(color: Colors.white),
            ),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to verify old password',
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred: $e',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }

  void changePassword(BuildContext context) async {
    try {
      await urlSetting.initialize();

      // Use the URL from UrlSetting
      Uri? uri =
          urlSetting.changePassword; // Use the URL method from UrlSetting
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final Map<String, String> data = {
        'MemberNo': MemberNo,
        'BranchNo': BranchNo,
        'NewPassword': newPassword.text,
      };
      final http.Response response = await http.post(
        uri!,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);

        if (jsonResponse != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Password reset successfully',
              style: TextStyle(color: Colors.white),
            ),
          ));
          // Navigate back after successful reset
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to reset password',
              style: TextStyle(color: Colors.white),
            ),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to reset password',
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'An error occurred: $e',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}
