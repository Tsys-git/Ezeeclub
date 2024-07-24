import 'package:flutter/material.dart';

class WaterBenefitsScreen extends StatelessWidget {
  final List<Map<String, String>> benefits = [
    {
      'title': 'Hydration',
      'description': 'Keeps your body hydrated and maintains bodily functions.',
    },
    {
      'title': 'Healthy Skin',
      'description': 'Helps in keeping the skin healthy and glowing.',
    },
    {
      'title': 'Weight Loss',
      'description':
          'Aids in weight loss by increasing metabolism and reducing appetite.',
    },
    {
      'title': 'Flushes Out Toxins',
      'description':
          'Flushes out toxins from the body and prevents kidney stones.',
    },
    {
      'title': 'Improves Brain Function',
      'description': 'Improves concentration, cognition, and mood.',
    },
    {
      'title': 'Regulates Body Temperature',
      'description': 'Helps in regulating body temperature.',
    },
    {
      'title': 'Boosts Energy',
      'description':
          'Prevents dehydration, which can cause fatigue and lack of energy.',
    },
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

  WaterBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 20.0,
            flexibleSpace: FlexibleSpaceBar(
              title: SafeArea(
                child: Text(
                  'Benefits of Drinking Water',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.teal],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            pinned: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8, // Adjust as needed
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final benefit = benefits[index];
                  final gradient = gradients[index % gradients.length];
                  return _buildBenefitItem(
                      benefit['title']!, benefit['description']!, gradient);
                },
                childCount: benefits.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(
      String title, String description, Gradient gradient) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
