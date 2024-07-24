// import 'dart:async';

// import 'package:ezeeclub/models/User.dart';
// import 'package:ezeeclub/pages/Features/PTRecords.dart';
// import 'package:ezeeclub/pages/Features/caloriesBurn.dart';
// import 'package:ezeeclub/pages/Features/dietPlan.dart';
// import 'package:ezeeclub/pages/Features/notifications.dart';
// import 'package:ezeeclub/pages/Features/waterBenefits.dart';
// import 'package:ezeeclub/pages/Features/workout.dart';
// import 'package:ezeeclub/pages/extraFeatures/food.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:ezeeclub/pages/step.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// class HomeScreenMember extends StatefulWidget {
//   final UserModel usermodel;

//   const HomeScreenMember({Key? key, required this.usermodel}) : super(key: key);

//   @override
//   State<HomeScreenMember> createState() => _HomeScreenMemberState();
// }

// class _HomeScreenMemberState extends State<HomeScreenMember> {
//   GenerativeModel _model = GenerativeModel(
//     model: 'gemini-1.5-flash-latest',
//     apiKey: "AIzaSyCJAX0v1KtTu963AME6LK3c5CG8RCNgZYs",
//   );
//   List<String> _quotes = [
//     "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
//     "The only way to achieve the impossible is to believe it is possible. - Charles Kingsleigh",
//     "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
//     "It does not matter how slowly you go as long as you do not stop. - Confucius",
//     "The will to win, the desire to succeed, the urge to reach your full potential... these are the keys that will unlock the door to personal excellence. - Confucius",
//     "Start where you are. Use what you have. Do what you can. - Arthur Ashe",
//     "Believe you can and you're halfway there. - Theodore Roosevelt",
//     "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
//     "Success usually comes to those who are too busy to be looking for it. - Henry David Thoreau",
//     "You don't have to be great to start, but you have to start to be great. - Zig Ziglar",
//   ];
//   bool _isLoading = true;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     fetchQuotes();
//   }

//   Future<void> fetchQuotes() async {
//     final prompt =
//         '10 Tips about how to make your workouts effective. add # before the number .tips: always follow the same pattern';
//     final content = [Content.text(prompt)];
//     final response = await _model.generateContent(content);
//     print(response);

//     setState(() {
//       _quotes = response.text!.split('#').map((quote) {
//         // Remove asterisks and trim whitespace
//         String trimmedQuote = quote.replaceAll('*', '').trim();
//         trimmedQuote = trimmedQuote.replaceAll('.', '').trim();
//         trimmedQuote = trimmedQuote.replaceAll(':', ' :').trim();

//         // Remove numbers and special symbols

//         // Remove leading numbers and spaces
//         trimmedQuote = trimmedQuote.replaceFirst(RegExp(r'^\d*'), '');

//         // Trim again to remove any leading or trailing spaces
//         trimmedQuote = trimmedQuote.trim();

//         return trimmedQuote;
//       }).toList();

//       _isLoading = false;
//     });

//     print(_quotes);
//   }

//   final int caloriesBurned = 730;
//   final int caloriesGoal = 299; // Example goal

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//         backgroundColor: Colors.black,

//         leading: Builder(
//           builder: (context) => IconButton(
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//             icon: ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: CircleAvatar(
//                 radius: screenWidth * 0.05,
//                 backgroundImage: AssetImage('assets/splashScreen.jpg'),
//               ),
//             ),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome back!!!",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Text("${widget.usermodel.fullName}",
//                 selectionColor: Colors.white,
//                 style: TextStyle(color: Colors.white, fontSize: 20)
//                 // style: Theme.of(context).textTheme.bodySmall,
//                 ),
//           ],
//         ),

//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return NotificationScreen();
//                   },
//                 ),
//               );
//             },
//             icon: Icon(Icons.notifications, color: Colors.white),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.card_giftcard, color: Colors.white),
//           ),
//         ],
//       ),
//       drawer: AppDrawer(
//         userModel: widget.usermodel,
//       ),
//       floatingActionButton: Tooltip(
//         message: "click here to get a Motivational Quotes.",
//         child: FloatingActionButton(
//           focusColor: Theme.of(context).primaryColor,
//           backgroundColor: Theme.of(context).primaryColor,
//           onPressed: () {
//             fetchQuotes();
//           },
//           child: Icon(Icons.self_improvement, color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 10,
//             ),
            
         
//             _whatToDoToday(screenWidth),
//             SizedBox(height: screenWidth * 0.02),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: _buildWorkoutCard(context, screenWidth, 1),
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Container(
//                   width: 3.0, // Adjust this value for the desired width
//                   height:
//                       height * 0.15, // Adjust this value for the desired height
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Expanded(
//                   flex: 1,
//                   child: _buildPtRecord(),
//                 ),
//               ],
//             ),
//             SizedBox(height: screenWidth * 0.04),
//             SizedBox(height: screenWidth * 0.02),
//             _builddailyQoutes(screenWidth, context),
//             // _buildQuotesCard(
//             //   _quotes[5],
//             //   screenWidth,
//             //   context,
//             // ),
//              SizedBox(height: screenWidth * 0.04),
         
//             _buildWaterDrinkingCard(screenWidth),
//             SizedBox(height: screenWidth * 0.02),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: _buildInfoCard(screenWidth, 'Steps', ' Not Found', '0',
//                       Icons.directions_walk, "assets/steps.png"),
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Container(
//                   width: 3.0, // Adjust this value for the desired width
//                   height:
//                       height * 0.15, // Adjust this value for the desired height
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Expanded(
//                   flex: 1,
//                   child: GestureDetector(
//                       onTap: () {
//                         Get.to(() => CalorieBurningTipsScreen());
//                       },
//                       child: _buildCaloriesCard(screenWidth, 1000)),
//                 ),
//               ],
//             ),

//             SizedBox(height: screenWidth * 0.02),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: _trackYourProgress(context, screenWidth, ""),
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Container(
//                   width: 3.0, // Adjust this value for the desired width
//                   height:
//                       height * 0.15, // Adjust this value for the desired height
//                   color: Colors.white,
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Expanded(
//                   flex: 1,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return DietPlanScreen(
//                               userModel: widget.usermodel,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     child: _buildInfoCard(screenWidth, 'Diet Plan', '', '0',
//                         Icons.food_bank_outlined, "assets/dietplan.png"),
//                   ),
//                 ),
//               ],
//             ),

            
//             // SizedBox(height: screenWidth * 0.04),
//             // _buildfoodsection(screenWidth),
//             SizedBox(height: screenWidth * 0.04),

//             _buildfeedlikesection(screenWidth, context),

//             SizedBox(height: screenWidth * 0.04),

//             _buildwhatNewInTheGym(screenWidth, context),
//             SizedBox(height: screenWidth * 0.02),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _trackYourProgress(
//       BuildContext context, double screenWidth, String img) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Card(
//         color: Theme.of(context).primaryColor, // Use card color from theme
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Track Your Progress',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: screenWidth * 0.06,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10), // Add spacing between title and image
//               Icon(
//                 Icons.bar_chart,
//                 size: 50,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 10), // Spacing between icon and date
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: screenWidth * 0.06,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                   height: 10), // Spacing between date and progress indicators
//               // Text(
//               //   'Calories Burned: 500',
//               //   style: TextStyle(
//               //       color: Colors.white, fontSize: screenWidth * 0.04),
//               // ),
//               // LinearProgressIndicator(
//               //   value: 0.5, // Example value for progress
//               //   backgroundColor: Colors.white54,
//               //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               // ),
//               // SizedBox(height: 10), // Spacing between progress bar and steps
//               // Text(
//               //   'Steps Taken: 7500',
//               //   style: TextStyle(
//               //       color: Colors.white, fontSize: screenWidth * 0.04),
//               // ),
//               // LinearProgressIndicator(
//               //   value: 0.75, // Example value for progress
//               //   backgroundColor: Colors.white54,
//               //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               // ),
//               // SizedBox(height: 10), // Spacing between progress bars
//               // Text(
//               //   'Workouts Completed: 4/5',
//               //   style: TextStyle(
//               //       color: Colors.white, fontSize: screenWidth * 0.04),
//               // ),
//               // LinearProgressIndicator(
//               //   value: 0.8, // Example value for progress
//               //   backgroundColor: Colors.white54,
//               //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               // ),
//               // SizedBox(height: 10), // Spacing between progress bars
//               // Text(
//               //   'Keep up the great work!',
//               //   style: TextStyle(
//               //     color: Colors.white,
//               //     fontStyle: FontStyle.italic,
//               //     fontSize: screenWidth * 0.045,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCaloriesCard(double caloriesGoal, double screenWidth) {
//     if (caloriesGoal <= 0) {
//       return Container(); // Handle edge case gracefully
//     }

//     double progress = 100 / caloriesGoal;

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(40.0),
//         // border: Border.all(
//         //   color: Colors.black!, // Customize border color based on theme
//         //   width: 1.0,
//         // ),
//       ),
//       child: Card(
//         color: Theme.of(context).primaryColor,
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Calories',
//                       style: TextStyle(
//                           color: Colors.white, fontSize: screenWidth * 0.02)),
//                   Icon(
//                     Icons.local_fire_department,
//                     size: screenWidth * 0.015,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   SizedBox(
//                     height: 80,
//                     width: 80,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3.0,
//                       value: progress.clamp(0.0, 12.0),
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       backgroundColor: Colors.grey,
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '{....}',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: screenWidth * 0.02),
//                         textAlign: TextAlign.center,
//                       ),
//                       Text(
//                         '/kCal',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: screenWidth * 0.01),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard(double screenWidth, String title, String value,
//       String unit, IconData icon, String img) {
//     StepController stepController = StepController();
//     return Center(
//       child: Container(
//         width: double.infinity,
//         child: Card(
//           // color: Theme.of(context).cardColor,
//           color: Color.fromARGB(47, 255, 255, 255),
//           child: Padding(
//             padding: EdgeInsets.all(12),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(img,
//                     width: screenWidth * 0.2,
//                     height: screenWidth * 0.3,
//                     fit: BoxFit.cover),
//                 //Icon(icon, size: screenWidth * 0.25),
//                 Center(child: Text(title,textAlign:TextAlign.center, style: TextStyle(fontSize: 20))),
//                 Center(
//                   child: Text(
//                     (title == "Steps")
//                         ? stepController.stepCount.value.toString()
//                         : value,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: screenWidth * 0.06,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWaterDrinkingCard(double screenWidth) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(screenWidth * 0.04),
//         // border: Border.all(
//         //   color: Theme.of(context).primaryColor,
//         //   width: 3.0,
//         // ),
//       ),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return WaterBenefitsScreen();
//               },
//             ),
//           );
//         },
//         child: Card(
//           color: Color.fromARGB(66, 161, 161, 161),
//           child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Are you Drinking enough Water ?',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.06,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                                        Image.asset("assets/man.png", height: 100, width: 100),

//                   ],
//                 ),
//                 Text(
//                   'Know the benefits',
//                   style: TextStyle(
//                     color: Theme.of(context).textTheme.bodySmall?.color,
//                     fontSize: screenWidth * 0.05,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return WaterBenefitsScreen();
//                             },
//                           ),
//                         );
//                       },
//                       child: Text("Click Here",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.05,
//                           )),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _whatToDoToday(double screenWidth) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(screenWidth * 0.04),
//         // border: Border.all(
//         //   color: Theme.of(context).primaryColor,
//         //   width: 1.0,
//         // ),
//       ),
//       child: Card(
//         // color: Theme.of(context).cardColor,
//         color: Color.fromARGB(66, 161, 161, 161),
//         child: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.04),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('What to do Today ?',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.bodyMedium?.color,
//                           fontSize: screenWidth * 0.06)),
//                   SizedBox(height: screenWidth * 0.01),
//                   Text('Yesterday was {.....} ',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.bodySmall?.color,
//                           fontSize: screenWidth * 0.05)),
//                 ],
//               ),
//               // IconButton(
//               //   onPressed: () {},
//               //   icon: Icon(Icons.forward_sharp),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWorkoutCard(BuildContext context, double screenWidth, int i) {
//     return Card(
//       margin: EdgeInsets.all(10.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       color: Theme.of(context).primaryColor,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Workout',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.06,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Icon(Icons.fitness_center),
//               ],
//             ),
//             SizedBox(height: 5.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     "Your body can stand almost anything. It’s your mind that you have to convince.",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.04,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.to(() => workoutScreen(
//                           userModel: widget.usermodel,
//                         ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Theme.of(context).primaryColor,
//                     backgroundColor: Colors.white, // Background color

//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12), // Border radius
//                     ),
//                   ),
//                   child: Text('Start Workout'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPtRecord() {
//     return Container(
//       height: 150,
//       child: GestureDetector(
//         onTap: () {
//           Get.to(() => PTRecords(
//                 userModel: widget.usermodel,
//               ));
//         },
//         child: Card(
//           color: Colors.grey[700],
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.record_voice_over,
//                 color: Colors.white, // Icon color
//                 size: 24.0, // Icon size
//               ),
//               SizedBox(
//                 width: 8.0,
//                 height: 20,
//               ), // Space between icon and text
//               Center(
//                 child: Text(
//                   'PT RECORDS',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16.0, // Text size
//                     color: Colors.white, // Text color
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildfoodsection(double screenWidth) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () {
//             Get.to(() => FoodGrid());
//           },
//           child: Card(
//             color: Theme.of(context).cardColor,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // Image.asset(
//                       //   'assets/motivation.png',
//                       //   width: 36.0,
//                       //   height: 36.0,
//                       // ),
//                       SizedBox(width: 10),
//                       Text(
//                         'Food Intake.',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.07,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Infoo about the food that you can intake',
//                     style: TextStyle(
//                       fontStyle: FontStyle.italic,
//                       fontSize: screenWidth * 0.05,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         // Card(
//         //   child: ReelsScreen(),
//         // )
//       ],
//     );
//   }

//   Widget _builddailyQoutes(double screenWidth, BuildContext context) {
//     late PageController _pageController;
//     int _currentPage = 0;
//     late Timer _timer;
//     _pageController = PageController(
//       initialPage: _currentPage,
//     );

//     // Start timer to automatically move to next quote every 5 seconds
//     // _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
//     //   if (_currentPage < _quotes.length - 3) {
//     //     _currentPage++;
//     //   } else {
//     //     _currentPage = 0; // Restart from the first quote
//     //   }
//     //   _pageController.animateToPage(
//     //     _currentPage,
//     //     duration: Duration(milliseconds: 500),
//     //     curve: Curves.easeInExpo,
//     //   );
//     // });

//     return SizedBox(
//       height: screenWidth * 0.4, // Adjusted height relative to screen width
//       child: PageView.builder(
//         // controller: _pageController,
//         scrollDirection: Axis.horizontal,
//         itemCount: _quotes.length *
//             2, // Double the itemCount for infinite looping effect
//         itemBuilder: (context, index) {
//           int currentIndex = index % _quotes.length;
//           return _buildQuotesCard(
//             _quotes[currentIndex + 2],
//             screenWidth,
//             context,
//           );
//         },
//       ),
//     );
//   }
// }

// class Announcement {
//   final String imagePath;
//   final String title;
//   final String subtitle;

//   Announcement(this.imagePath, this.title, this.subtitle);
// }

// Widget _buildwhatNewInTheGym(double screenWidth, BuildContext context) {
//   // Simulated list of real-life announcements
//   List<Announcement> announcements = [
//     Announcement(
//       'assets/login.png',
//       'Grand Opening Event',
//       'Join us on July 1st for our grand opening!',
//     ),
//     Announcement(
//       'assets/login.png',
//       'New Fitness Classes',
//       'Introducing yoga and pilates classes starting next week.',
//     ),
//     Announcement(
//       'assets/login.png',
//       'Special Membership Offers',
//       'Sign up for a year membership and get one month free! Limited time offer.',
//     ),
//     Announcement(
//       'assets/login.png',
//       'Fitness Challenge',
//       'Join our summer fitness challenge and win exciting prizes!',
//     ),
//   ];

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // Image.asset(
//                 //   'assets/announcement.png',
//                 //   width: 36.0,
//                 //   height: 36.0,
//                 //   //color: Theme.of(context).primaryColor,
//                 // ),
//                 SizedBox(width: 10),
//                 Text(
//                   'What\'s New',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               'Catch what\'s new or upcoming in the gym.',
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontSize: 16.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(
//         height: screenWidth * 0.6, // Adjusted height relative to screen width
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: announcements.length,
//           itemBuilder: (context, index) {
//             return _buildHorizontalCard(
//                 announcements[index].imagePath,
//                 announcements[index].title,
//                 announcements[index].subtitle,
//                 screenWidth,
//                 context);
//           },
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildHorizontalCard(String imagePath, String title, String subtitle,
//     double screenWidth, BuildContext context) {
//   return Container(
//     width: screenWidth * 0.8, // Adjusted width relative to screen width
//     padding: EdgeInsets.all(8.0),
//     child: Card(
//       elevation: 2.0,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8.0),
//               child: Image.asset(
//                 imagePath,
//                 width: double.infinity, // Full width within the card
//                 height: screenWidth *
//                     0.2, // Adjusted height relative to screen width
//                 // fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.normal,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 4.0),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildQuotesCard(
//     String title, double screenWidth, BuildContext context) {
//   return Container(
//     width: screenWidth * 1, // Adjusted width relative to screen width
//     padding: EdgeInsets.all(4.0),
//     child: Card(
//       elevation: 2.0,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 8.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.normal,
//                       fontSize: 12.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildfeedlikesection(double screenWidth, BuildContext context) {
//   double height = MediaQuery.of(context).size.height;
//   // Simulated list of real-life announcements
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Card(
//         color: Color.fromARGB(66, 161, 161, 161),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   // Image.asset(
//                   //   'assets/motivation.png',
//                   //   width: 36.0,
//                   //   height: 36.0,
//                   // ),
//                   SizedBox(width: 10),
//                   Text(
//                     'Get motivated',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 'Get inspired with our latest motivational videos.',
//                 style: TextStyle(
//                   fontStyle: FontStyle.italic,
//                   fontSize: screenWidth * 0.05,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//       // Card(
//       //   child: ReelsScreen(),
//       // )
//     ],
//   );
// }
