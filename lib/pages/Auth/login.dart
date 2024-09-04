import 'dart:convert';
import 'dart:io';

import 'package:ezeeclub/pages/HomeScreenMember.dart';
import 'package:ezeeclub/pages/MD/MDDashBoard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/userLogin.dart';
import '../splashsreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscureText = true;
  bool isLoggedIn = false;
  String loginType = "member";
  String storedUrl = "loading";

  void togglePasswordVisibility() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    // checkLoginStatus(); // Check login status when screen initializes
    getUrl();
  }

  void getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedUrl = prefs.getString('app_url')!;
    });
  }

  // Future<void> checkLoginStatus() async {
  //   await UserLogin().restoreLoginState(); // Ensure login state is restored
  //   setState(() {
  //     isLoggedIn = UserLogin().isLoggedIn; // Update isLoggedIn state
  //   });

  //   if (isLoggedIn) {
  //     Get.off(() => HomeScreenMember());
  //   }
  // }

  void login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (storedUrl == null || storedUrl.isEmpty) {
        showSnackBar(
            context, 'Stored URL is not available or empty', Colors.red);
        return;
      }

      // Determine the URL and data based on login type
      String loginUrl = '';
      Map<String, String> data;

      if (!username.isAlphabetOnly) {
        loginUrl = 'http://${storedUrl}/MobileAppService.svc/UserLogin';
        data = {
          'UserName': username,
          'Password': password,
        };
        setState(() {
          loginType = "member";
        });
      } else {
        loginUrl = 'http://${storedUrl}/MobileAppService.svc/EmployeeLogin';
        data = {
          'MemberName': username,
          'Password': password,
        };
        setState(() {
          loginType = "employee";
        });
      }

      final Uri url = Uri.parse(loginUrl);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);

        final dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse != null &&
            jsonResponse is List &&
            jsonResponse.isNotEmpty) {
          final Map<String, dynamic> userData = jsonResponse[0];
          final String isActive = userData['Active'] ?? "No";

          print(userData);

          if (isActive.toLowerCase() == "yes") {
            if (loginType == "employee") {
              String designation =
                  userData["Designation"].toString().toLowerCase();
              if (designation == "md") {
                prefs.setString('mdname', userData['EmpName']);
                prefs.setBool('isLoggedIn', true);
                prefs.setString('currentuser', "md");
                Get.offAll(() => DashboardScreen());
                showSnackBar(context, 'Login successful', Colors.green);
              } else {
                showSnackBar(context, 'Unauthorized access.', Colors.red);
              }
            } else {
              // Member login processing
              prefs.setBool('isLoggedIn', true);
              UserLogin().setMobileNo(userData['MobileNo']);
              UserLogin().setName(userData['MemberName']);
              UserLogin().setMemberNo(userData['MemberNo']);
              UserLogin().setBranchNo(userData['Branchno']);
              UserLogin().setEmail(userData['Email']);
              UserLogin().setMembershipStatus(userData['Membershipstatus']);
              UserLogin().setLocation(userData['Location']);
              userData['BirthDate'] != null && userData['BirthDate'] != ""
                  ? UserLogin().setDOB(userData['BirthDate'])
                  : "01/01/1980";
              prefs.setString('currentuser', "member");
              Get.off(() => HomeScreenMember());
              showSnackBar(context, 'Member Login successful', Colors.green);
            }
          } else if (userData['Password'] == null) {
            showSnackBar(context, 'Invalid credentials ', Colors.red);
          } else {
            showSnackBar(
                context,
                'User is inactive, please contact the administrator.',
                Colors.red);
          }
        } else {
          showSnackBar(
              context, 'Invalid credentials or empty response.', Colors.red);
        }
      } else {
        showSnackBar(context, 'Login failed.', Colors.red);
      }
    } on SocketException {
      showSnackBar(
          context, 'No Internet connection. Check your network.', Colors.red);
    } on FormatException {
      showSnackBar(
          context, 'URL Not set properly. Please contact support.', Colors.red);
    } catch (error) {
      showSnackBar(context, 'Error during login:', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Image.asset(
            "assets/splashscreene.png",
            color: Colors.white,
          ),
          title: Text("Login", style: TextStyle(fontSize: 16)),
          subtitle: Text(storedUrl.replaceAll(".ezeeclub.net", ""),
              style: TextStyle(fontSize: 14)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Row(
                    children: [
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
              children: [
                SizedBox(height: 10),
                Text(
                  'Welcome To EzeeClub',
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
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                _buildTextField(
                  context,
                  usernameController,
                  'Member Id  ',
                  icon: Icons.person,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  context,
                  passwordController,
                  'Password ',
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
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Sign In',
                          style: TextStyle(color: Colors.black),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
