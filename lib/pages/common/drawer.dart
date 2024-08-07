import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/att/att.dart';
import 'package:ezeeclub/pages/drawer/help.dart';
import 'package:ezeeclub/pages/drawer/profile.dart';
import 'package:flutter/material.dart';
import 'package:ezeeclub/pages/Auth/login.dart';
import 'package:ezeeclub/pages/Features/rules.dart';
import 'package:ezeeclub/pages/drawer/about.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Features/calender.dart';
import '../Features/heathDetails.dart';

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
                  children: [
                    Image.asset(
                      "assets/downloaded/6.png",
                      height: 120,
                    )
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
                      return AttendanceScreen();
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
              buildDrawerListTile(Icons.health_and_safety, "Health Details",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HeathdetailsScreen(
                        userModel: widget.userModel,
                      );
                    },
                  ),
                );
              }),

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

              buildDrawerListTile(Icons.date_range_sharp, "Calender", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CalendarScreen(
                        memberNo: widget.userModel.member_no,
                        branchNo: widget.userModel.BranchNo,
                      );
                    },
                  ),
                );
              }),
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

              buildDrawerListTile(Icons.star, "Rate Us", () {
                _showRateUsBottomSheet(context);
              }),
              buildDrawerListTile(Icons.help, "Help", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HelpPage();
                    },
                  ),
                );
              }),
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

  void _showRateUsBottomSheet(BuildContext context) {
    var _rating = 4;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Rate Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'If you like our app, please rate us!',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openRatingPage();
                },
                child: Text('Rate Now'),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Later'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openRatingPage() async {
    const url =
        'https://play.google.com/store/apps/details'; // Replace with your app's store URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
