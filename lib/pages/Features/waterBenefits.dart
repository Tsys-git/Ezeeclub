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
      backgroundColor: Colors.black.withOpacity(0.9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 20.0,
            flexibleSpace: FlexibleSpaceBar(
              title: SafeArea(
                child: Text(
                  'Benefits of Drinking Water',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            backgroundColor: Colors.black.withOpacity(0.9),
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
                  return _buildBenefitItem(
                      benefit['title']!, benefit['description']!, context);
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
      String title, String description, BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10.0),
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
