import 'package:flutter/material.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context)
            .primaryColor, // Assuming you want a blue color for the app bar
        title: Text(
          'Social Media',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          padding: EdgeInsets.all(20.0),
          children: [
            _buildSocialIcon('Instagram', "assets/social/instagram.png",
                'https://www.instagram.com/', context // Instagram URL
                ),
            _buildSocialIcon('Facebook', "assets/social/facebook.png",
                'https://www.facebook.com/', context // Facebook URL
                ),
            _buildSocialIcon(
                'Youtube',
                "assets/social/youtube.png",
                'https://www.youtube.com/', // YouTube URL
                context),
            _buildSocialIcon(
                'Twitter',
                "assets/social/twitter.png",
                'https://twitter.com/', // Twitter URL
                context),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
      String name, String img, String url, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 70,
              width: 70,
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch the URL
}
