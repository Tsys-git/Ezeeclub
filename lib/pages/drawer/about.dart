
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logoxtrim.png', // Make sure to add your image to the assets folder and update pubspec.yaml
              height: 100,
              width: 100,
            ),
            SizedBox(height: 16),
            Text(
              '“We Care about Fitness of your Business”',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact us'),
              onTap: () {
                openwebsite("https://tsysinfo.com/contact.html");
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Visit our website'),
              onTap: () {
                openwebsite("https://tsysinfo.com/");
              },
            ),

            ListTile(
              leading: Image.asset(
                "assets/social/instagram.png",
                height: 25,
                width: 25,
              ),
              title: Text('Instagram'),
              onTap: () {
                openwebsite("https://www.instagram.com/tsysinfotechnologies/");
              },
            ),

            ListTile(
              leading: Image.asset(
                "assets/social/facebook.png",
                height: 25,
                width: 25,
              ),
              title: Text('Facebook'),
              onTap: () {
                openwebsite("https://www.facebook.com/tsysinfotechnologies/");
              },
            ),
            ListTile(
              leading: Image.asset(
                "assets/social/twitter.png",
                height: 25,
                width: 25,
              ),
              title: Text('Twitter'),
              onTap: () {
                openwebsite("https://twitter.com/TsysinfoL/");
              },
            ),

            Expanded(
                child: Container()), // To push the following text to the bottom
            Text(
              'Developed By Tsysinfo Technologies',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              '© Copyrights © 2024',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openwebsite(String url) async {
  // Replace with your app's store URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
