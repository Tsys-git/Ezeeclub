import 'package:flutter/material.dart';

class CalorieBurningTip {
  final String title;
  final String description;
  final IconData? icon;

  CalorieBurningTip({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class CalorieBurningTipsScreen extends StatelessWidget {
  final List<CalorieBurningTip> tips = [
    CalorieBurningTip(
      title: 'Running',
      description:
          'Running is a great way to burn calories. Start with a brisk pace for better results.',
      icon: Icons.run_circle_outlined,
    ),
    CalorieBurningTip(
      title: 'Swimming',
      description:
          'Swimming is a full-body workout that burns a lot of calories without stressing your joints.',
      icon: Icons.water,
    ),
    CalorieBurningTip(
      title: 'Cycling',
      description:
          'Cycling helps in burning calories and improving cardiovascular health.',
      icon: Icons.pedal_bike,
    ),
    CalorieBurningTip(
      title: 'Dancing',
      description: 'Dancing is a fun way to burn calories and stay active.',
      icon: Icons.sports_gymnastics,
    ),
    CalorieBurningTip(
      title: 'Stair Climbing',
      description:
          'Climbing stairs is a simple way to burn calories and strengthen leg muscles.',
      icon: Icons.stairs,
    ),
    CalorieBurningTip(
      title: 'Yoga',
      description:
          'Yoga improves flexibility, strength, and balance while burning calories.',
      icon: Icons.self_improvement,
    ),
    CalorieBurningTip(
      title: 'Rowing',
      description:
          'Rowing is a low-impact exercise that engages multiple muscle groups and burns calories.',
      icon: Icons.rowing,
    ),
  ];

  final List<Gradient> gradients = [
    LinearGradient(
      colors: [Colors.teal, Colors.teal],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [Colors.red, Colors.red],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [Colors.green, Colors.green],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [Colors.purple, Colors.purple],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [Colors.cyan, Colors.cyan],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [Colors.orange, Colors.orange],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [Colors.blue, Colors.blue],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
  ];

   CalorieBurningTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Burning Tips',style:TextStyle(fontSize: 24)),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 7.0,
          mainAxisSpacing: 7.0,
        ),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          final gradient = gradients[index % gradients.length];
          return _buildTipCard(context, tip, gradient);
        },
      ),
    );
  }

  Widget _buildTipCard(
      BuildContext context, CalorieBurningTip tip, Gradient gradient) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   tip.icon,
            //   size: 40,
            //   color: Colors.white,
            // ),
            SizedBox(height: 10.0),
            Text(
              tip.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              tip.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
