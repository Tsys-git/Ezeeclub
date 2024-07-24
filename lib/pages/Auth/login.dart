import 'dart:io';
import 'package:ezeeclub/pages/Auth/forgotPass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/User.dart';
import '../HomeScreenMember.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;
  var loginScreenUserName = "".obs;
  var userid = "".obs;
  var userpass = "".obs;
  void login(BuildContext context) async {
    isLoading(true);
    final String username = usernameController.text;
    final String password = passwordController.text;

    final Uri url = Uri.parse(
        'http://oneabovefit.ezeeclub.net/MobileAppService.svc/UserLogin');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, String> data = {
      'UserName': username,
      'Password': password,
    };
    print(username);
    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);

        if (jsonResponse.isNotEmpty) {
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
          loginScreenUserName(fullName);
          userid(username);
          userpass(password);
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

          // if (fullName != 'Not Available') {
          //   if (username.startsWith('E')) {
          //     Get.offAll(() => DashboardScreen());
          //     showSnackBar(context, 'Employee Login successful', Colors.green);
          //   } else {
          //     Get.off(() => HomeScreenMember(usermodel: userModel));
          //     showSnackBar(context, 'Member Login successful', Colors.green);
          //   }
          // } else {
          //   showSnackBar(context,
          //       'Incorrect Username or Password\nPlease check it.', Colors.red);
          // }
          if (fullName != 'Not Available') {
            Get.off(() => HomeScreenMember(usermodel: userModel));
            showSnackBar(context, 'Member Login successful', Colors.green);
          } else {
            showSnackBar(context, 'Member Login Unsuccessful', Colors.red);
          }
        }
      } else {
        showSnackBar(context, 'Login failed', Colors.red);
        print('Login failed. Status code: ${response.statusCode}');
      }
    } on SocketException {
      showSnackBar(
          context,
          'No Internet connection . Ensure that your internet is on..',
          Colors.red);

      throw Exception('No Internet connection');
    } catch (error) {
      showSnackBar(context, 'Error during login: $error', Colors.red);
      print('Error during login: $error');
    } finally {
      isLoading(false);
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
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.put(LoginController());
  bool isObscureText = true; // To toggle password visibility
  void togglePasswordVisibility() {
    if (isObscureText) {
      print("Password vissibility 1.....");
    } else {
      print("Password vissibility 0.....");
    }

    setState(() {
      isObscureText = !isObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400.withOpacity(0.5),
              Colors.blue.shade900.withOpacity(0.5),
            ],
           
          ),
          shape: BoxShape.rectangle,
        ),            child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset('assets/login.png',
                //     color: Theme.of(context).primaryColor,
                //     height: height * 0.3,
                //     width: double.infinity),
                // SizedBox(height: 10),
                Text(
                  'Welcome To EZEE CLUB',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
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
                Text(
                  "Hello, ${_controller.loginScreenUserName.value}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(context, _controller.usernameController,
                    'Username or email',
                    icon: Icons.person),
                SizedBox(height: 10),
                _buildTextField(
                    context, _controller.passwordController, 'Password',
                    isPassword: true,
                    icon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        togglePasswordVisibility();
                      },
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.to(() => PasswordResetScreen());
                      },
                      child: Text(
                        "Forgot password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Obx(() => ElevatedButton(
                      onPressed: _controller.isLoading.value
                          ? null
                          : () => _controller.login(context),
                      // Disable button when login process is ongoing
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Pass the BuildContext to the login function
                      child: _controller.isLoading.value
                          ? CircularProgressIndicator()
                          : Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                    )),
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
            color: Theme.of(context).textTheme.bodyLarge!.color,
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
            borderSide: BorderSide(color: Colors.green[500]!, width: 2.0),
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }
}
