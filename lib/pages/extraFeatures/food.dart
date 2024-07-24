import 'package:flutter/material.dart';
import 'dart:math';

class FoodGrid extends StatelessWidget {
  final List<Map<String, String>> vegFoods = [
    {
      "name": "Broccoli",
      "info":
          "Rich in vitamins and fiber. Supports digestion and immune health.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Broccoli_and_cross_section_edit.jpg/220px-Broccoli_and_cross_section_edit.jpg"
    },
    {
      "name": "Quinoa",
      "info":
          "Complete protein, gluten-free grain. Provides essential amino acids.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Broccoli_and_cross_section_edit.jpg/220px-Broccoli_and_cross_section_edit.jpg"
    },
    {
      "name": "Almonds",
      "info": "Healthy fats, protein, and fiber. Good for heart health.",
      "image": ""
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Broccoli_and_cross_section_edit.jpg/220px-Broccoli_and_cross_section_edit.jpg"
    }
  ];

   FoodGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Shuffle the food lists each time the app is used
    vegFoods.shuffle(Random());

    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Foods'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Veg Foods',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: vegFoods.length,
                itemBuilder: (context, index) {
                  final food = vegFoods[index % vegFoods.length];
                  return Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.network(
                          food[
                              'image']!, // Replace with the actual URL of the image
                          height: 80,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            food['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            food['info']!,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
