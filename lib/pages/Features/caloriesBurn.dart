import 'package:flutter/material.dart';

class CalorieBurningTip {
  final String title;
  final String description;
  final IconData? icon;
  final String imageUrl;

  CalorieBurningTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.imageUrl,
  });
}

class CalorieBurningTipsScreen extends StatelessWidget {
  final List<CalorieBurningTip> tips = [
    CalorieBurningTip(
      title: 'Running',
      description:
          'Running is a great way to burn calories. Start with a brisk pace for better results.',
      icon: Icons.run_circle_outlined,
      imageUrl: 'assets/calories/running.jpg',
    ),
    CalorieBurningTip(
      title: 'Swimming',
      description:
          'Swimming is a full-body workout that burns a lot of calories without stressing your joints.',
      icon: Icons.water,
      imageUrl: 'assets/calories/swim.jpg',
    ),
    CalorieBurningTip(
      title: 'Cycling',
      description:
          'Cycling helps in burning calories and improving cardiovascular health.',
      icon: Icons.pedal_bike,
      imageUrl: 'assets/calories/cycling.jpg',
    ),
    CalorieBurningTip(
      title: 'Dancing',
      description: 'Dancing is a fun way to burn calories and stay active.',
      icon: Icons.sports_gymnastics,
      imageUrl: 'assets/calories/dance.jpg',
    ),
    CalorieBurningTip(
      title: 'Stair Climbing',
      description:
          'Climbing stairs is a simple way to burn calories and strengthen leg muscles.',
      icon: Icons.stairs,
      imageUrl: 'assets/calories/stairs.jpg',
    ),
    CalorieBurningTip(
      title: 'Yoga',
      description:
          'Yoga improves flexibility, strength, and balance while burning calories.',
      icon: Icons.self_improvement,
      imageUrl: 'assets/calories/yoga.jpg',
    ),
    CalorieBurningTip(
      title: 'Rowing',
      description:
          'Rowing is a low-impact exercise that engages multiple muscle groups and burns calories.',
      icon: Icons.rowing,
      imageUrl: 'assets/calories/rowing.jpg',
    ),
  ];

  CalorieBurningTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Burning Tips', style: TextStyle(fontSize: 24)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return _buildTipCard(context, tip);
        },
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, CalorieBurningTip tip) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              tip.imageUrl,
              height: 230, // Set a fixed height for the card
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Overlay with gradient
          Container(
            height: 230, // Match the height of the image
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.4),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Text content at the bottom
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  textScaler: TextScaler.linear(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  textScaler: TextScaler.linear(1.5),
                  tip.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
