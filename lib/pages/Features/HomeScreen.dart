import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/Auth/login.dart';
import 'package:ezeeclub/pages/Features/Extra.dart';
import 'package:ezeeclub/pages/Features/PTRecords.dart';
import 'package:ezeeclub/pages/Features/calender.dart';
import 'package:ezeeclub/pages/Features/heathDetails.dart';
import 'package:ezeeclub/pages/Features/rewards.dart';
import 'package:ezeeclub/pages/Features/rules.dart';
import 'package:ezeeclub/pages/Features/slotBooking.dart';
import 'package:ezeeclub/pages/drawer/profile.dart';
import 'package:ezeeclub/pages/drawer/socialMedia.dart';
import 'package:flutter/material.dart';
import 'package:ezeeclub/pages/Features/dietPlan.dart';
import 'package:ezeeclub/pages/Features/notifications.dart';

class HomeScreen extends StatefulWidget {
  final UserModel usermodel;

  const HomeScreen({super.key, required this.usermodel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Hello , ${widget.usermodel.fullName}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            floating: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NotificationScreen();
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.notifications)),
            ],
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/splashScreen.jpg'),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: [
                buildCard(Icons.notifications, "Notification", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NotificationScreen();
                      },
                    ),
                  );
                }),
                buildCard(Icons.food_bank, "Diet Plan", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DietPlanScreen(
                          userModel: widget.usermodel,
                        );
                      },
                    ),
                  );
                }),
                buildCard(Icons.date_range, "Calendar", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CalendarScreen( memberNo: widget.usermodel.member_no, branchNo: widget.usermodel.BranchNo,);
                      },
                    ),
                  );
                  // Implement functionality for Calendar
                }),
                buildCard(Icons.rule_sharp, "Rules", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RulesScreen();
                      },
                    ),
                  );
                  // Implement functionality for Rules
                }),
                buildCard(Icons.health_and_safety, "Health Details", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HeathdetailsScreen(
                          userModel: widget.usermodel,
                        );
                      },
                    ),
                  );
                  // Implement functionality for Health Details
                }),
                buildCard(Icons.call, "Slot Booking", () {
                  // slotBookingScreen()
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Slotbooking();
                      },
                    ),
                  );
                  // Implement functionality for Slot Booking
                }),
                buildCard(Icons.card_giftcard, "Rewards", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RewardsScreen();
                      },
                    ),
                  );
                  // Implement functionality for Rewards
                }),
                buildCard(Icons.nordic_walking, "PT Records", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PTRecords(
                          userModel: widget.usermodel,
                        );
                      },
                    ),
                  );
                  // Implement functionality for PT Records
                }),
                buildCard(Icons.onetwothree, "Extra Feature 1", () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (builder) {
                      return extraF();
                    },
                  ));
                  // Implement functionality for Extra Feature 1
                }),
                buildCard(Icons.onetwothree, "Extra Feature 2", () {
                  // Implement functionality for Extra Feature 2
                }),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            children: [
              DrawerHeader(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/splashScreen.jpg'),
                  ),
                ),
              ),
              buildDrawerListTile(Icons.person, "Profile", () {
                // ProfileScreen()
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen(
                        userModel: widget.usermodel,
                      );
                    },
                  ),
                );
              }),
              buildDrawerListTile(Icons.info, "About", () {}),
              buildDrawerListTile(Icons.help, "Help", () {}),
              buildDrawerListTile(Icons.star, "Rate Us", () {}),
              buildDrawerListTile(Icons.social_distance, "Social Media", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SocialMedia();
                    },
                  ),
                );
              }),
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

  Widget buildCard(IconData icon, String text, VoidCallback onTap) {
    return Card(
      child: Center(
        child: TextButton(
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
