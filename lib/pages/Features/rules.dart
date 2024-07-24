import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
//Colors.grey[800]
        title: Text(
          "Gym Rules",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        children: const [
          RuleItem(
              ruleNumber: 1,
              ruleTitle: 'Proper Attire',
              ruleDescription:
                  'All gym users must wear appropriate workout attire, including athletic shoes and proper workout clothing.',
              flex: 2, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 2,
              ruleTitle: 'Wipe Down Equipment',
              ruleDescription:
                  'After using any gym equipment, please wipe it down with the provided cleaning supplies to maintain cleanliness and hygiene.',
              flex: 1, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 3,
              ruleTitle: 'No Food or Drink',
              ruleDescription:
                  'Food and drink, except for water in a sealable container, are not allowed in the gym area to prevent spills and maintain cleanliness.',
              flex: 3, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 4,
              ruleTitle: 'Respect Others',
              ruleDescription:
                  'Be respectful of others using the gym facilities. Avoid loud noises, hogging equipment, or engaging in disruptive behavior.',
              flex: 1, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 5,
              ruleTitle: 'Proper Hygiene',
              ruleDescription:
                  'Maintain proper personal hygiene by showering before and after your workout, and using deodorant to avoid unpleasant odors.',
              flex: 2, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 6,
              ruleTitle: 'Use Spotter for Heavy Lifting',
              ruleDescription:
                  'When lifting heavy weights, always use a spotter to ensure safety and prevent injuries.',
              flex: 1, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 7,
              ruleTitle: 'Return Equipment',
              ruleDescription:
                  'After using weights or other equipment, please return them to their designated places to keep the gym tidy and organized.',
              flex: 2, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 8,
              ruleTitle: 'Follow Staff Instructions',
              ruleDescription:
                  'Follow any instructions or guidelines provided by the gym staff to ensure a safe and enjoyable workout experience for everyone.',
              flex: 1, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 9,
              ruleTitle: 'Limit Cell Phone Use',
              ruleDescription:
                  'Minimize cell phone use in the gym area to avoid distractions and allow others to focus on their workouts.',
              flex: 2, // Example flex value
              img: "assets/dietplan.png"),
          RuleItem(
              ruleNumber: 10,
              ruleTitle: 'No Horseplay',
              ruleDescription:
                  'Engaging in horseplay, roughhousing, or any other unsafe behavior is strictly prohibited in the gym.',
              flex: 1, // Example flex value
              img: "assets/dietplan.png"),
        ],
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final int ruleNumber;
  final String ruleTitle;
  final String ruleDescription;
  final String img;
  final int flex; // Flex value for controlling the size of the container

  const RuleItem({
    required this.ruleNumber,
    required this.ruleTitle,
    required this.ruleDescription,
    required this.img,
    required this.flex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[200],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50.0, // Adjust this value for the desired width
              height: 50.0, // Adjust this value for the desired height
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white, // Set the border color
                  width: 2.0, // Adjust this value for the desired border width
                ),
              ),
              child: Center(
                child: Text(
                  ruleNumber.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: flex, // Set the flex value for the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.asset(img),
                  Text(
                    ruleTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    ruleDescription,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
