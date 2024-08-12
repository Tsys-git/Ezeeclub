import 'package:ezeeclub/controllers/notificationController.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController nc = NotificationController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Notification",style:TextStyle(fontSize: 24)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/notifications.png",
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
            ),
            TextButton(
                onPressed: () {
                  nc.fetchNotification("6400","2");
                },
                child: Text("fetch Notifications ",style:TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}
