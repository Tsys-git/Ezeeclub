import 'dart:async';
import 'dart:convert';

import 'package:ezeeclub/HomeScreen.dart';
import 'package:ezeeclub/models/StepsData.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/Auth/login.dart';
import 'package:ezeeclub/pages/Features/PTRecords.dart';
import 'package:ezeeclub/pages/Features/calender.dart';
import 'package:ezeeclub/pages/Features/caloriesBurn.dart';
import 'package:ezeeclub/pages/Features/dietPlan.dart';
import 'package:ezeeclub/pages/Features/notifications.dart';
import 'package:ezeeclub/pages/Features/planDetails.dart';
import 'package:ezeeclub/pages/Features/waterBenefits.dart';
import 'package:ezeeclub/pages/Features/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:ezeeclub/pages/steps/step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../whatto.dart';
import 'Features/heathDetails.dart';
import 'common/drawer.dart';
import 'steps/stepController.dart';
import 'package:http/http.dart' as http;

import 'package:card_swiper/card_swiper.dart';

import 'what to do/whattodotoday.dart';

class WeightData {
  WeightData(this.x, this.y);
  final String? x;
  final double? y;
}

class HomeScreenMember extends StatefulWidget {
  final UserModel usermodel;

  const HomeScreenMember({super.key, required this.usermodel});

  @override
  State<HomeScreenMember> createState() => _HomeScreenMemberState();
}

class _HomeScreenMemberState extends State<HomeScreenMember>
    with TickerProviderStateMixin {
  GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: "AIzaSyCJAX0v1KtTu963AME6LK3c5CG8RCNgZYs",
  );
  List<String> _quotes = [
    "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
    "The only way to achieve the impossible is to believe it is possible. - Charles Kingsleigh",
    "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
    "It does not matter how slowly you go as long as you do not stop. - Confucius",
    "The will to win, the desire to succeed, the urge to reach your full potential... these are the keys that will unlock the door to personal excellence. - Confucius",
    "Start where you are. Use what you have. Do what you can. - Arthur Ashe",
    "Believe you can and you're halfway there. - Theodore Roosevelt",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
    "Success usually comes to those who are too busy to be looking for it. - Henry David Thoreau",
    "You don't have to be great to start, but you have to start to be great. - Zig Ziglar",
  ];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int? stepsGoal;
  int caloriesGoal = 0;
  int _selectedIndex = 0;
  DateTime _startDate = DateTime.now();

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Duration of the animation
    )..forward(); // Start animation immediately

    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 1.0), // Start from the top
      end: Offset.zero, // End at the original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    ));

    fetchQuotes();
    _loadGoals();
    _loadStartDate();
  }

  Future<void> _loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String startDateStr = prefs.getString('startDate') ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    print(startDateStr);
    setState(() {
      _startDate = DateTime.parse(startDateStr);
    });
  }

  Future<void> _updateStartDate(DateTime newStartDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'startDate', DateFormat('yyyy-MM-dd').format(newStartDate));
    setState(() {
      _startDate = newStartDate;
    });
  }

  DateTime _getDateAtIndex(int index) {
    return _startDate.add(Duration(days: index));
  }

  Future<void> _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stepsGoal = prefs.getInt('stepsGoal') ?? 0;
      caloriesGoal = prefs.getInt('caloriesGoal') ?? 0;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchQuotes() async {
    const prompt =
        '10 Tips about how to make your workouts effective. add # before the number .tips: always follow the same pattern';
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    print(response);

    setState(() {
      _quotes = response.text!.split('#').map((quote) {
        // Remove asterisks and trim whitespace
        String trimmedQuote = quote.replaceAll('*', '').trim();
        trimmedQuote = trimmedQuote.replaceAll('.', '').trim();
        trimmedQuote = trimmedQuote.replaceAll(':', ' :').trim();

        // Remove leading numbers and spaces
        trimmedQuote = trimmedQuote.replaceFirst(RegExp(r'^\d*'), '');

        // Trim again to remove any leading or trailing spaces
        trimmedQuote = trimmedQuote.trim();

        return trimmedQuote;
      }).toList();

      _isLoading = false;
    });

    print(_quotes);
  }

  @override
  Widget build(BuildContext context) {
// Split user's date of birth string into day, month, and year parts
    List<String> dobParts = widget.usermodel.dob.split('/');
    int day = int.parse(dobParts[0]);
    int month = int.parse(dobParts[1]);
    int year = int.parse(dobParts[2]);

// Create DateTime object for user's date of birth
    DateTime userDob = DateTime(year, month, day);

// Get current date
    DateTime now = DateTime.now();

// Compare user's date of birth with current date
    bool isBirthday = userDob.day == now.day && userDob.month == now.month;

    print('User Date of Birth: $userDob');
    print('Current Date: $now');
    print('Is Birthday Today? $isBirthday');

    final double screenWidth = MediaQuery.of(context).size.width;
    final double scrrenheight = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: AppDrawer(
        userModel: widget.usermodel,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.purple.shade400.withOpacity(0.5),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.rectangle,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Image.asset(
                          'assets/downloaded/6.png', // Replace with your image asset path
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          fit: BoxFit
                              .cover, // Change to BoxFit.cover to fit the image inside the circle
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                     //   Scaffold.of(context).openDrawer();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.usermodel.fullName,
                              selectionColor: Colors.white,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.05)
                              // style: Theme.of(context).textTheme.bodySmall,
                              ),
                          Text(widget.usermodel.member_no,
                              selectionColor: Colors.white,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.05)
                              // style: Theme.of(context).textTheme.bodySmall,
                              ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return NotificationScreen();
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.notifications,
                              size: screenWidth * 0.05,
                            )),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return workoutScreen(
                                      userModel: widget.usermodel,
                                    );
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.sports_gymnastics,
                                size: screenWidth * 0.05)),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                isBirthday
                    ? _buildBirthdayCard(height)
                    : _buildCalendarScrollView(),

                SizedBox(height: screenWidth * 0.02),
                GestureDetector(
                  onTap: () {
                    Get.to(() => GymListScreen());
                  },
                  child: Container(
                      height: screenWidth * 0.7,
                      child:
                          _whatToDoToday(screenWidth, scrrenheight, context)),
                ),
                SizedBox(height: screenWidth * 0.02),

                Card(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        trackYourProgress(context, screenWidth, ""),
                        Divider(height: 2.0, color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildInfoCard(
                                  context,
                                  'Steps',
                                  ' Not Found',
                                  '0',
                                  Icons.directions_walk,
                                  "assets/steps.png"),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => CalorieBurningTipsScreen());
                                  },
                                  child: _buildCaloriesCard(context)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),

                SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => WaterBenefitsScreen());
                          },
                          child: Container(
                            height: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: _buildWaterDrinkingCard(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),

                // Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20.0),
                //     ),
                //     child: _buildWaterDrinkingCard(screenWidth)),
                // SizedBox(height: screenWidth * 0.02),

                SizedBox(height: screenWidth * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: screenWidth * 0.7,
                          child: ptrecordswidget(screenWidth)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: screenWidth * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DietPlanScreen(
                                    userModel: widget.usermodel,
                                  );
                                },
                              ),
                            );
                          },
                          child: _buildInfoCard(context, 'Diet Plan', '', '0',
                              Icons.food_bank_outlined, "assets/dietplan.png"),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenWidth * 0.04),
                // _buildQuotesCard(
                //   _quotes[5],
                //   screenWidth,
                //   context,
                // ),
                // SizedBox(height: screenWidth * 0.04),

                _builddailyQoutes(screenWidth, context),

                SizedBox(height: screenWidth * 0.04),
                _buildwhatNewInTheGym(context),
                SizedBox(height: screenWidth * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesCard(BuildContext context) {
    final StepController stepController = Get.put(StepController());
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double screenWidth = constraints.maxWidth;
      double scrrenHeight = constraints.maxHeight;
      double progress = stepController.stepCount.value * 0.063;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Add other decoration properties as needed
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: screenWidth * 0.1,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: screenWidth * 0.8,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // half of height/width for circular shape
                    ),
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: screenWidth * 0.1,
                      value: progress.clamp(0.0,
                          0.70), // clamp between 0 and 1 for CircularProgressIndicator
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (progress)
                            .toStringAsFixed(0), // Your calorie value here
                        style: TextStyle(
                            color: Colors.yellow, fontSize: screenWidth * 0.2),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'cal...',
                        style: TextStyle(
                            color: Colors.yellow, fontSize: screenWidth * 0.1),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text('Calories Burned',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.1)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoCard(BuildContext context, String title, String value,
      String unit, IconData icon, String img) {
    final StepController stepController = Get.put(StepController());
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double screenWidth = constraints.maxWidth;

      double screenheight = constraints.maxWidth;

      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: title != "Steps"
              ? Card(
                  color: Color.fromARGB(
                      35, 248, 245, 245), // Use card color from theme

                  //color: Colors.transparent,

                  child: title == "Steps"
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => StepCounter());
                          },
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  img,
                                  width: screenWidth * 0.5,
                                  height: screenheight * 0.6,
                                  fit: BoxFit.cover,
                                  //color: Theme.of(context).primaryColor
                                ),

                                //Icon(icon, size: screenWidth * 0.25),
                                Text(title,
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.13,
                                        color: Colors.white)),
                                Obx(() => Text(
                                      '${stepController.stepCount.value}',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              img,
                              width: screenWidth * 0.5,
                              height: screenheight * 0.6,
                              fit: BoxFit.cover,
                              //color: Theme.of(context).primaryColor
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            //Icon(icon, size: screenWidth * 0.25),
                            Text(title,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.13,
                                  color: Colors.white,
                                )),
                            Text(
                              (title == "Steps") ? "100" : value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                          ],
                        ),
                )
              : title == "Steps"
                  ? GestureDetector(
                      onTap: () {
                        Get.to(() => StepCounter());
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              img,
                              width: screenWidth * 0.5,
                              height: screenheight * 0.6,
                              fit: BoxFit.cover,
                              //color: Theme.of(context).primaryColor
                            ),

                            //Icon(icon, size: screenWidth * 0.25),
                            Text(title,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.13,
                                    color: Colors.white)),
                            Obx(() => Text(
                                  '${stepController.stepCount.value}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          img,
                          width: screenWidth * 0.5,
                          height: screenheight * 0.6,
                          fit: BoxFit.cover,
                          //color: Theme.of(context).primaryColor
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Icon(icon, size: screenWidth * 0.25),
                        Text(title,
                            style: TextStyle(
                              fontSize: screenWidth * 0.13,
                              color: Colors.white,
                            )),
                        Text(
                          (title == "Steps") ? "100" : value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ],
                    ),
        ),
      );
    });
  }

  Widget _whatToDoToday(
      double screenWidth, double scrrenheight, BuildContext context) {
    return Card(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
          ),
          child: _buildLargeLayout(context),
        ));
  }

  Widget _buildLargeLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'WHAT',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.24, // Adjust the font size here
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(1),
                            height: 1,
                          ),
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'To Do',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.1, // Adjust the font size here
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                            height: 0.8,
                          ),
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'Today',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.2, // Adjust the font size here
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: -20,
              left: screenWidth * 0.5, // Adjust positioning
              child: Image.asset(
                "assets/whattodo.png",
                width: screenWidth * 0.6,
                height: (screenHeight) + 20,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaterDrinkingCard(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = constraints.maxWidth;

        return Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ARE YOU DRINKING ENOUGH WATER ?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.06,
                          )),
                      Text("Know the Benefits.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.05,
                          )),
                    ],
                  ),
                ),
                // Image.asset(
                //   fit: BoxFit.cover,
                //   "assets/wdc.jpg",
                //   height: screenWidth * 5,
                //   width: screenWidth * 0.2,
                // ),
              ],
            ));
      },
    );
  }
/*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Are you drinking enough water?',
                          textScaler: TextScaler.linear(1.4),
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Optional: for emphasis
                          ),
                        ),
                        SizedBox(
                            height: 8), // Add spacing between text elements
                        Text(
                          'Know the benefits',
                          textScaler: TextScaler.linear(1.2),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8), // Add spacing between text and image
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      "assets/water.png",
                      fit: BoxFit.contain,
                      width: screenWidth * 0.3,
                    ),
                  ),
                ],
              ),*/

  Widget _buildWorkoutCard(BuildContext Context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints Constraints) {
      double height = Constraints.maxHeight;
      double width = Constraints.maxWidth;

      return Container(
        child: GestureDetector(
          onTap: () {
            Get.to(() => workoutScreen(userModel: widget.usermodel));
          },
          child: Card(
            color:
                Color.fromARGB(35, 248, 245, 245), // Use card color from theme
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workout',
                        textScaler: TextScaler.linear(1.5),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: width * 0.1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Your body can stand almost anything. It’s your mind that you have to convince.",
                          textScaler: TextScaler.linear(1.0),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget trackYourProgress(
      BuildContext context, double screenWidth, String img) {
    final List<WeightData> weightData = <WeightData>[
      WeightData('April', 83),
      WeightData('May', 78),
      WeightData('June', 73),
      WeightData('July', 76),
    ];

    final List<StepCountData> stepdata = <StepCountData>[
      StepCountData(date: "21/07", steps: 2000),
      StepCountData(date: "22/07", steps: 1800),
      StepCountData(date: "23/07", steps: 2300),
      StepCountData(date: "24/07", steps: 1700)
    ];
    // Find highest and lowest values in chartData
    double? minValue = weightData
        .map((data) => data.y)
        .reduce((curr, next) => curr! < next! ? curr : next);
    double? maxValue = weightData
        .map((data) => data.y)
        .reduce((curr, next) => curr! > next! ? curr : next);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: width * 0.06,
                        ),
                      ),
                    ),
                    Text(
                      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   "bar charts and pie charts",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: width * 0.06,
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Weight Graph",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.04,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(
                        border: Border.all(
                          color: const Color(0xff37434d),
                          width: 2,
                        ),
                      ),

                      minY: 40, // Minimum Y value
                      maxY: 100, // Maximum Y value
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 45), //  april
                            FlSpot(1, 50), // April
                            FlSpot(2, 75), // May
                            FlSpot(3, 80), // June
                            FlSpot(4, 70), // July
                          ],
                          isStepLineChart: false,
                          isCurved: true,
                          color: Colors.amber,
                          dotData:
                              FlDotData(show: true), // Show dots at each point
                          belowBarData: BarAreaData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Text(
                //   "Steps Graph",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: width * 0.04,
                //   ),
                // ),
                // Container(
                //   height: 200,
                //   child: SfCircularChart(
                //     series: <CircularSeries>[
                //       RadialBarSeries<StepCountData, String>(
                //         dataSource: stepdata,
                //         xValueMapper: (StepCountData stepdata, _) =>
                //             stepdata.date,
                //         yValueMapper: (StepCountData stepdata, _) =>
                //             stepdata.steps,
                //         cornerStyle: CornerStyle.bothCurve,
                //         radius: '100%',
                //       )
                //     ],
                //     tooltipBehavior: TooltipBehavior(
                //       enable: true,
                //       header: "Steps",
                //       tooltipPosition: TooltipPosition.pointer,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _builddailyQoutes(double screenWidth, BuildContext context) {
    int currentPage = 2;
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (currentPage < _quotes.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      // Update the swiper to the next page
    });

    return SizedBox(
      height: screenWidth * 0.6,
      child: Stack(
        children: [
          Swiper(
            itemCount: _quotes.length,
            autoplay: true,
            autoplayDelay: 5000,

            curve: Curves.bounceInOut,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Color.fromARGB(
                    35, 248, 245, 245), // Use card color from theme
                child: _buildQuotesCard(
                  _quotes[index],
                  screenWidth,
                  context,
                ),
              );
            },
            pagination: SwiperPagination(), // Add pagination dots
            onIndexChanged: (int index) {
              currentPage = index;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesCard(
      String quote, double screenWidth, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text("${quote}.",
            textAlign: TextAlign.center,
            textScaler: TextScaler.linear(1.4),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.03,
            )),
      ),
    );
  }

  Widget ptrecordswidget(double width) {
    return SizedBox(
      height: 150,
      child: GestureDetector(
        onTap: () {
          Get.to(() => PTRecords(userModel: widget.usermodel));
        },
        child: Card(
          color: Color.fromARGB(35, 248, 245, 245), // Use card color from theme
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.record_voice_over,
                color: Colors.white, // Icon color
                size: 24.0, // Icon size
              ),
              SizedBox(
                width: 8.0,
                height: 20,
              ), // Space between icon and text
              Center(
                child: Text(
                  textScaler: TextScaler.linear(2.0),
                  'PT\n RECORDS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // Text size
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarScrollView() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxWidth;

        DateTime currentDate = DateTime.now();

        return SizedBox(
          height: height * 0.4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              DateTime dayDate = _getDateAtIndex(index);
              bool isCurrentDate = DateFormat('yyyy-MM-dd').format(dayDate) ==
                  DateFormat('yyyy-MM-dd').format(currentDate);
              bool isPastDate = dayDate.isBefore(currentDate);


              return Container(
                width: width * 0.2,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: _selectedIndex == index
                      ? (isCurrentDate
                          ? LinearGradient(
                              colors: [Colors.amber, Colors.yellow],
                              begin: Alignment.bottomLeft,
                            )
                          : LinearGradient(
                              colors: [Colors.grey, Colors.white],
                              begin: Alignment.bottomLeft,
                            ))
                      : (isPastDate
                          ? LinearGradient(colors: [Colors.grey, Colors.grey])
                          : LinearGradient(
                              colors: [Colors.white, Colors.white])),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (!isPastDate) {
                      int newIndex = (index + 1) % 4;
                      setState(() {
                        _selectedIndex = newIndex;
                      });
                      DateTime newStartDate = _startDate!
                          .add(Duration(days: newIndex - _selectedIndex));
                      await _updateStartDate(newStartDate);
                      if (isCurrentDate) {
                        // Navigate to TodayScreen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodayScreen()));
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayDate.day.toString(),
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: isCurrentDate
                              ? Colors.black
                              : (isPastDate ? Colors.black : Colors.black),
                        ),
                      ),
                      Text(
                        DateFormat.MMM().format(dayDate),
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: isCurrentDate
                              ? Colors.black
                              : (isPastDate ? Colors.black : Colors.black),
                        ),
                      ),
                      Text(
                        DateFormat.E().format(dayDate).toUpperCase(),
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: isCurrentDate
                              ? Colors.black
                              : (isPastDate ? Colors.black54 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBirthdayCard(double height) {
    return Card(
      elevation: 1, // Adds a shadow to the card
      color: Color.fromARGB(255, 73, 31, 28),
      margin: EdgeInsets.all(10), // Provides padding around the card
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Wish You Many Many Happy Returns Of The Day.',
                      textScaler: TextScaler.linear(1.2),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/cake.png",
                    width: 100,
                  )
                ],
              ),
              Center(
                child: Text(
                  textScaler: TextScaler.linear(1),
                  '- From Admin',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                textScaler: TextScaler.linear(1),
                'May all your wishes come true.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildwhatNewInTheGym(BuildContext context) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints Constraints) {
      double screenWidth = Constraints.maxWidth;
      double screenheight = Constraints.maxHeight;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and icon row
            Row(
              children: [
                Text(
                  'What\'s New',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/announcement.png',
                  width: 36.0,
                  height: 36.0,
                  //color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Description text
            Text(
              'Catch what\'s new in the gym.',
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: screenWidth * 0.05,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            // Horizontal cards with flexible height

            Container(
              height: screenWidth > 400 ? 180 : 270,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: screenWidth * 0.7,
                      child: Card(
                        color: Color.fromARGB(
                            35, 248, 245, 245), // Use card color from theme
                        child: ListTile(
                          title: Text(
                              textScaler: TextScaler.linear(1),
                              'Get Fit for Summer with Our New Classes!',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              textScaler: TextScaler.linear(1),
                              'Dive into our fresh lineup of high-energy classes tailored to help you achieve your summer fitness goals. Limited spots available—reserve yours now!'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5), // Space between cards
                  // Card 2 (Replace with your actual card widget)
                  SizedBox(
                    width: screenWidth * 0.7, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text(
                            ' Introducing Our State-of-the-Art Equipment!',
                            textScaler: TextScaler.linear(1),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Experience the latest in fitness technology with our newly upgraded equipment. Enjoy improved workouts and track your progress like never before.',
                          textScaler: TextScaler.linear(1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5), // Space between cards
                  // Card 3 (Replace with your actual card widget)
                  SizedBox(
                    width: screenWidth * 0.7, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text(
                          'Join Our 6-Week Transformation Challenge!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaler: TextScaler.linear(1),
                        ),
                        subtitle: Text(
                          'Commit to a healthier you with our structured program including training, nutrition, and support. Transform your body and mind—sign up today!',
                          textScaler: TextScaler.linear(1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5), // Space between cards
                  // Card 4 (Replace with your actual card widget)
                  SizedBox(
                    width: screenWidth * 0.7, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text(
                            'Elevate Your Workout with Personal Training Specials!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaler: TextScaler.linear(1)),
                        subtitle: Text(
                          'Take advantage of our limited-time discounts on personal training packages. Work one-on-one with expert trainers to reach your fitness goals faster.',
                          textScaler: TextScaler.linear(1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildQuotesCard(
    String title, double screenWidth, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
