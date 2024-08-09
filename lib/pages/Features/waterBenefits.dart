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
      'title': 'Regulates Body Temperature',
      'description': 'Helps in regulating body temperature.',
    },
    {
      'title': 'Boosts Energy',
      'description':
          'Prevents dehydration, which can cause fatigue and lack of energy.',
    },
  ];

WaterBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Benefits of Drinking Water'),
        backgroundColor: Colors.black.withOpacity(0.9),
      ),
      backgroundColor: Colors.black.withOpacity(0.9),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: benefits.length,
        itemBuilder: (context, index) {
          final benefit = benefits[index];
          return _buildBenefitCard(
              benefit['title']!, benefit['description']!);
        },
      ),
    );
  }

  Widget _buildBenefitCard(String title, String description) {
    return Card(
      color: Colors.grey.withOpacity(0.9),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
