import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/att/att.dart';
import 'package:ezeeclub/pages/drawer/profile.dart';
import 'package:flutter/material.dart';
import 'package:ezeeclub/pages/Auth/login.dart';
import 'package:ezeeclub/pages/Features/rules.dart';
import 'package:ezeeclub/pages/drawer/about.dart';
import 'package:ezeeclub/pages/drawer/socialMedia.dart';

class AppDrawer extends StatefulWidget {
  final UserModel userModel;

  const AppDrawer({super.key, required this.userModel});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                   Image.asset("assets/downloaded/6.png",height: 120,)
                  ],
                ),
              ),
              buildDrawerListTile(Icons.person, "Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen(
                        userModel: widget.userModel,
                      );
                    },
                  ),
                );
              }),

              buildDrawerListTile(Icons.date_range, "Attendance", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AttendaceScreen();
                    },
                  ),
                );
              }),

              // buildDrawerListTile(Icons.lock, "Change Password", () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return ResetPasswordMember(
              //           memberNo: widget.userModel.member_no,
              //           BranchNo: widget.userModel.BranchNo,
              //         );
              //       },
              //     ),
              //   );
              // }),
              // buildDrawerListTile(Icons.receipt_long, "Plan Details", () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return PlanDetailsPage(
              //             member_no: widget.userModel.member_no,
              //             branchNo: widget.userModel.BranchNo);
              //       },
              //     ),
              //   );
              // }),
              // buildDrawerListTile(Icons.health_and_safety, "Health Details", () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return HeathdetailsScreen(
              //           userModel: widget.userModel,
              //         );
              //       },
              //     ),
              //   );
              // }),

              buildDrawerListTile(Icons.rule_sharp, "Rules", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RulesScreen();
                    },
                  ),
                );
              }),

              // buildDrawerListTile(Icons.date_range, "Calender", () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return CalendarScreen(
              //           memberNo: widget.userModel.member_no,
              //           branchNo: widget.userModel.BranchNo,
              //         );
              //       },
              //     ),
              //   );
              // }),
              // buildDrawerListTile(Icons.call, "Slot Booking", () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return Slotbooking();
              //       },
              //     ),
              //   );
              // }),

              buildDrawerListTile(Icons.info, "About", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AboutUsPage();
                    },
                  ),
                );
              }),

              // buildDrawerListTile(Icons.social_distance, "Social Media", () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return SocialMedia();
              //       },
              //     ),
              //   );
              // }),

              buildDrawerListTile(Icons.star, "Rate Us", () {}),
              buildDrawerListTile(Icons.help, "Help", () {}),
              buildDrawerListTile(Icons.feedback, "Feedback", () {}),
              buildDrawerListTile(Icons.exit_to_app, "Logout", () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
      onTap: onTap,
    );
  }
}
