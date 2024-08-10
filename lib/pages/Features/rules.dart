import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _goToNextPage() {
    if (_currentPage < 9) { // Assuming there are 10 pages
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      setState(() {
        _currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Gym Rules",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: ClampingScrollPhysics(), // Adjust to your needs
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                RuleItem(
                  ruleNumber: 1,
                  ruleTitle: 'Proper Attire',
                  ruleDescription:
                      'All gym users must wear appropriate workout attire, including athletic shoes and proper workout clothing.',
                  flex: 2,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 2,
                  ruleTitle: 'Wipe Down Equipment',
                  ruleDescription:
                      'After using any gym equipment, please wipe it down with the provided cleaning supplies to maintain cleanliness and hygiene.',
                  flex: 1,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 3,
                  ruleTitle: 'No Food or Drink',
                  ruleDescription:
                      'Food and drink, except for water in a sealable container, are not allowed in the gym area to prevent spills and maintain cleanliness.',
                  flex: 3,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 4,
                  ruleTitle: 'Respect Others',
                  ruleDescription:
                      'Be respectful of others using the gym facilities. Avoid loud noises, hogging equipment, or engaging in disruptive behavior.',
                  flex: 1,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 5,
                  ruleTitle: 'Proper Hygiene',
                  ruleDescription:
                      'Maintain proper personal hygiene by showering before and after your workout, and using deodorant to avoid unpleasant odors.',
                  flex: 2,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 6,
                  ruleTitle: 'Use Spotter for Heavy Lifting',
                  ruleDescription:
                      'When lifting heavy weights, always use a spotter to ensure safety and prevent injuries.',
                  flex: 1,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 7,
                  ruleTitle: 'Return Equipment',
                  ruleDescription:
                      'After using weights or other equipment, please return them to their designated places to keep the gym tidy and organized.',
                  flex: 2,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 8,
                  ruleTitle: 'Follow Staff Instructions',
                  ruleDescription:
                      'Follow any instructions or guidelines provided by the gym staff to ensure a safe and enjoyable workout experience for everyone.',
                  flex: 1,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 9,
                  ruleTitle: 'Limit Cell Phone Use',
                  ruleDescription:
                      'Minimize cell phone use in the gym area to avoid distractions and allow others to focus on their workouts.',
                  flex: 2,
                  img: "assets/motivation.png",
                ),
                RuleItem(
                  ruleNumber: 10,
                  ruleTitle: 'No Horseplay',
                  ruleDescription:
                      'Engaging in horseplay, roughhousing, or any other unsafe behavior is strictly prohibited in the gym.',
                  flex: 1,
                  img: "assets/motivation.png",
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _goToPreviousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800], // Button color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800], // Button color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: flex, // Set the flex value for the container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset(
                      img,
                      height: 250,
                    )),
                    SizedBox(height: 8.0),
                    Text(
                      ruleTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      ruleDescription,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
