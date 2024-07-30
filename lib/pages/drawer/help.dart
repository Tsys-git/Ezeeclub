// help_page.dart

import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSectionTitle('Getting Started'),
            _buildHelpItem(
              'How to Sign Up',
              'To sign up, click on the Sign Up button on the login screen and follow the instructions.',
            ),
            _buildHelpItem(
              'How to Log In',
              'Enter your credentials (email and password) and click on Log In to access your account.',
            ),
            _buildHelpItem(
              'Forgot Password',
              'If you forgot your password, click on Forgot Password on the login screen and follow the prompts.',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Profile'),
            _buildHelpItem(
              'View Profile',
              'To view your profile, go to the Profile tab in the bottom navigation bar.',
            ),
            _buildHelpItem(
              'Edit Profile',
              'To edit your profile, go to Profile > Edit Profile and make the desired changes.',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Workouts'),
            _buildHelpItem(
              'Track Workouts',
              'Go to Workouts > My Workouts to view and track your workout history.',
            ),
            _buildHelpItem(
              'Create New Workout',
              'To create a new workout, click on the "+" button in the My Workouts screen and fill in the details.',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Settings'),
            _buildHelpItem(
              'Change App Settings',
              'To change app settings, go to Settings from the Profile tab and customize as per your preference.',
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Contact Support'),
            _buildHelpItem(
              'Need Help?',
              'For any assistance or queries, contact our support team at support@gymapp.com.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 12.0),
        Divider(),
      ],
    );
  }
}
