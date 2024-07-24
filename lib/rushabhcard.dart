import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const CustomCard({super.key, 
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double imageHeight = width; // Adjust the ratio as needed
        double titleFontSize = width * 0.1; // Adjust the ratio as needed
        double subtitleFontSize = width * 0.05; // Adjust the ratio as needed

        return Padding(
          padding: EdgeInsets.all(16.0), // Outer padding
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: imageHeight / 2),
                decoration: BoxDecoration(
                  color: Color.fromARGB(98, 136, 235, 140),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Inner padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: imageHeight / 5),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: (width - imageHeight) / 2, // Center the image
                child: Image.asset(
                  imageUrl,
                  width: imageHeight,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
