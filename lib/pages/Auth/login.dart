import 'dart:convert';
import 'dart:io';

import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/HomeScreenMember.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/userLogin.dart';
import '../splashsreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscureText = true;
  bool isLoggedIn = false;

  void togglePasswordVisibility() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check login status when screen initializes
  }

  Future<void> checkLoginStatus() async {
    await UserLogin().restoreLoginState(); // Ensure login state is restored
    setState(() {
      isLoggedIn = UserLogin().isLoggedIn; // Update isLoggedIn state
    });

    if (isLoggedIn) {
      // If logged in, navigate to Dashboard
    }
  }

  void login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final String username = usernameController.text;
    final String password = passwordController.text;
    String? storedUrl;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedUrl = prefs.getString('app_url');

    final Uri url = Uri.parse('http://$storedUrl/UserLogin');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, String> data = {
      'UserName': username,
      'Password': password,
    };

    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse != null) {
          final Map<String, dynamic> userData = jsonResponse[0];
          final String fullName = userData['MemberName'] ?? 'Not Available';
          final String email = userData['Email'] ?? 'Not Available';
          final String phoneNumber = userData['MobileNo'] ?? 'Not Available';
          final String dob = userData['BirthDate'] ?? 'Not Available';
          final String brName = userData['BranchName'] ?? 'Not Available';
          final String memberNo = userData['MemberNo'] ?? 'Not Available';
          final String memStatus =
              userData['Membershipstatus'] ?? 'Not Available';
          final String branchNo = userData['BranchNo'] ?? '1';
          print(branchNo);

          print(fullName);
          final UserModel userModel = UserModel(
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            dob: dob,
            br_name: brName,
            member_no: memberNo,
            mem_status: memStatus,
            BranchNo: branchNo,
          );
          if (fullName != "Not Available") {
            Get.off(() => HomeScreenMember(usermodel: userModel));
            showSnackBar(context, 'Member Login successful', Colors.green);
          }
        } else {
          showSnackBar(
            context,
            'Login failed. Invalid credentials.',
            Colors.red,
          );
        }
      } else {
        showSnackBar(
          context,
          'Login failed. Status code: ${response.statusCode}',
          Colors.red,
        );
        print('Login failed. Status code: ${response.statusCode}');
      }
    } on SocketException {
      showSnackBar(
        context,
        'No Internet connection. Ensure that your internet is on.\nOr check the url setup is done properly ',
        Colors.red,
      );
      throw Exception('No Internet connection');
    } catch (error) {
      showSnackBar(
        context,
        'Error during login: $error',
        Colors.red,
      );
      print('Error during login: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login", style: TextStyle(fontSize: 24)),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Row(
                    children: const [
                      // Image.asset(
                      //   "assets/confirm.png",
                      //   height: 30,
                      //   width: 30,
                      //   color: Colors.white,
                      // ),
                      SizedBox(width: 20),
                      Text('Confirmation', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  content: Text('Are you sure you want to release the URL?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        releaseUrl(); // Call the method to release URL
                        Get.off(() =>
                            SplashScreen()); // Navigate back to SplashScreen
                      },
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('No'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Welcome To EZEE CLUB',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Please Sign In to Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  context,
                  usernameController,
                  'Member Id',
                  icon: Icons.person,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  context,
                  passwordController,
                  'Password',
                  isPassword: true,
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscureText ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      togglePasswordVisibility();
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: isLoading ? null : () => login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Sign In',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String hint, {
    IconData? icon,
    bool isPassword = false,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: isPassword && isObscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: Theme.of(context).iconTheme.color,
                )
              : null,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }

  void releaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn'); // Remove login status
    prefs.setString('app_url', ""); // Clear stored URL
  }
}
