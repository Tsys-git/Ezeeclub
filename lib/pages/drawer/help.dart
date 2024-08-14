import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _buildExpandableSection(
            'Getting Started',
            [
              _buildHelpItem(
                'How to Log In',
                'Enter your credentials (member ID and password) and click on Log In to access your account.',
              ),
              _buildHelpItem(
                'Forgot Password',
                'If you forgot your password, click on Forgot Password on the login screen and follow the prompts.',
              ),
            ],
          ),
          _buildExpandableSection(
            'Profile',
            [
              _buildHelpItem(
                'View Profile',
                'To view your profile, go to the Profile tab in the App Drawer.',
              ),
              _buildHelpItem(
                'Edit Profile',
                'To edit your profile, go to Profile > Edit Profile and make the desired changes.',
              ),
            ],
          ),
          _buildExpandableSection(
            'Change Password',
            [
              _buildHelpItem(
                'Change Password',
                'To change your password, go to the Profile tab in the App Drawer, then click on the lock icon in the app bar.',
              ),
            ],
          ),
          _buildExpandableSection(
            'Plan Details',
            [
              _buildHelpItem(
                'View Plan Details',
                'To view your Plan Details, go to the Profile tab in the App Drawer.',
              ),
            ],
          ),
          _buildExpandableSection(
            'Settings',
            [
              _buildHelpItem(
                'Change App Settings',
                'To change app settings, go to Settings from the Profile tab and customize as per your preference.',
              ),
            ],
          ),
          _buildExpandableSection(
            'Contact Support',
            [
              _buildHelpItem(
                'Need Help?',
                'For any assistance or queries, contact our support team at support@tsysinfo.in',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(String title, List<Widget> helpItems) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Section title color
        ),
      ),
      children: helpItems,
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Add margin between cards
      elevation: 4.0, // Add shadow for better separation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0), // Padding inside the card
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
              fontSize: 14.0, color: Colors.white), // Description text color
        ),
      ),
    );
  }
}
