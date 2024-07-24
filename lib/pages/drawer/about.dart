import 'package:flutter/material.dart';

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
              'assets/ezee.png', // Make sure to add your image to the assets folder and update pubspec.yaml
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
            SizedBox(height: 24),
            Text(
              'Version : 1.0.0',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact us'),
              onTap: () {
                // Implement your contact functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Visit our website'),
              onTap: () {
                // Implement your website navigation functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.facebook),
              title: Text('Like us on Facebook'),
              onTap: () {
                // Implement your Facebook navigation functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate us on the Play Store'),
              onTap: () {
                // Implement your Play Store rating functionality here
              },
            ),
            Expanded(child: Container()), // To push the following text to the bottom
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
