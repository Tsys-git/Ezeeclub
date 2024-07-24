import 'dart:async';

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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:card_swiper/card_swiper.dart';

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

        // Remove numbers and special symbols

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
    // Assuming widget.usermodel.dob is a string in "dd/MM/yyyy" format
    String dob = widget.usermodel.dob;

// Split user's date of birth string into day, month, and year parts
    List<String> dobParts = dob.split('/');
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
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.up,
        spaceBetweenChildren: 0,
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            label: 'Event\'s',
            labelBackgroundColor: Colors.transparent,
            onTap: () => {
              Get.to(() => CalendarScreen(
                    memberNo: widget.usermodel.member_no,
                    branchNo: widget.usermodel.BranchNo,
                  ))
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.health_and_safety),
            backgroundColor: Colors.green,
            labelBackgroundColor: Colors.transparent,
            label: 'Health Details',
            onTap: () =>
                {Get.to(() => HeathdetailsScreen(userModel: widget.usermodel))},
          ),
        ],
      ),
      drawer: AppDrawer(
        userModel: widget.usermodel,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade400.withOpacity(0.5),
                Colors.blue.shade900.withOpacity(0.5),
              ],
              
            ),
            shape: BoxShape.rectangle,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.03),
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
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit
                              .cover, // Change to BoxFit.cover to fit the image inside the circle
                        ),
                      );
                    }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.usermodel.fullName,
                            selectionColor: Colors.white,
                            style: TextStyle(color: Colors.white, fontSize: 20)
                            // style: Theme.of(context).textTheme.bodySmall,
                            ),
                        Text(widget.usermodel.member_no,
                            selectionColor: Colors.white,
                            style: TextStyle(color: Colors.white, fontSize: 14)
                            // style: Theme.of(context).textTheme.bodySmall,
                            ),
                      ],
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
                            icon: Icon(Icons.notifications)),
                        IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.exit_to_app)),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                isBirthday
                    ? _buildBirthdayCard(height)
                    : SlideTransition(
                        position: _slideAnimation,
                        child: _buildCalendarScrollView()),

                SizedBox(height: screenWidth * 0.02),
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child:
                          _whatToDoToday(screenWidth, scrrenheight, context)),
                ),
                SizedBox(height: screenWidth * 0.02),
                SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: screenWidth * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: _buildWaterDrinkingCard(context),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.0),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: screenWidth * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
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
                            child: _buildInfoCard(
                                context,
                                'Diet Plan',
                                '',
                                '0',
                                Icons.food_bank_outlined,
                                "assets/dietplan.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: trackYourProgress(context, screenWidth, ""),
                ),
                // Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20.0),
                //     ),
                //     child: _buildWaterDrinkingCard(screenWidth)),
                // SizedBox(height: screenWidth * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: screenWidth * 0.7,
                        child: _buildInfoCard(context, 'Steps', ' Not Found',
                            '0', Icons.directions_walk, "assets/steps.png"),
                      ),
                    ),
                    // SizedBox(width: screenWidth * 0.03),
                    // Container(
                    //   width: 3.0, // Adjust this value for the desired width
                    //   height:
                    //       height * 0.15, // Adjust this value for the desired height
                    //   color: Colors.white,
                    // ),
                    // SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => CalorieBurningTipsScreen());
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              height: screenWidth * 0.7,
                              child: _buildCaloriesCard(context))),
                    ),
                  ],
                ),

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
                          child: _buildWorkoutCard(context)),
                    ),
                    // SizedBox(width: screenWidth * 0.03),
                    // Container(
                    //   width: 3.0, // Adjust this value for the desired width
                    //   height:
                    //       height * 0.15, // Adjust this value for the desired height
                    //   color: Colors.white,
                    // ),
                    // SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      flex: 1,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: screenWidth * 0.7,
                          child: ptrecordswidget()),
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
        child: Card(
          color: Color.fromARGB(35, 248, 245, 245), // Use card color from theme
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
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
                              color: Colors.yellow,
                              fontSize: screenWidth * 0.2),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'cal...',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: screenWidth * 0.1),
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
          child: Card(
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
          ),
        ),
      );
    });
  }

  Widget _whatToDoToday(
      double screenWidth, double scrrenheight, BuildContext context) {
    print(screenWidth);
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      child: Card(
        color: Color.fromARGB(35, 248, 245, 245), // Use card color from theme
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _buildLargeLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        print("inside the what to do screenHeight : $screenHeight");
        print("inside the what to do  screenWidth : $screenWidth");
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Text(
                          'What to do Today?',
                          style: TextStyle(
                            fontSize: screenWidth *
                                0.15, // Adjust font size as needed
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Yesterday was\n{.....} Day',
                        style: TextStyle(
                          fontSize:
                              screenHeight * 0.08, // Adjust font size as needed
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: -20,
              left: screenWidth * 0.5,
              child: Image.asset(
                width: screenWidth * 0.6,
                "assets/whattodo.png",
                height: screenHeight * 1.22,
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
      double height = constraints.maxHeight;

      return GestureDetector(
        onTap: () {
          Get.to(() => WaterBenefitsScreen());
        },
        child: Card(
          //color: Theme.of(context).primaryColor,
          color: Color.fromARGB(47, 255, 255, 255),

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              //color: Colors.grey,
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.all(
                12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Are you Drinking enough Water ?',
                          style: TextStyle(
                            fontSize: screenWidth * 0.1,

                            // Adjust color if needed
                          ),
                        ),
                        Text(
                          'Know the benefits',
                          style: TextStyle(
                            color: Colors.grey,

                            fontSize: height * 0.07,
                            // Adjust color if needed
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/water.png",
                    height: screenWidth * 0.3,
                    fit: BoxFit.contain, // Ensure the image fits its height
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWorkoutCard(BuildContext Context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints Constraints) {
      double height = Constraints.maxHeight;

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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: height * 0.1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Your body can stand almost anything. It’s your mind that you have to convince.",
                          style: TextStyle(
                              color: Colors.white, fontSize: height * 0.05),
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
          child: Card(
            color: Colors.transparent,
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
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        majorGridLines: MajorGridLines(width: 0.2),
                        // Hides vertical gridlines
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: minValue! - 5,
                        maximum: maxValue! + 5,
                        majorGridLines: MajorGridLines(width: 0.2),
                      ),
                      series: <CartesianSeries>[
                        SplineSeries<WeightData, String>(
                            dataSource: weightData,
                            dashArray: const <double>[50, 5],
                            xValueMapper: (WeightData data, _) => data.x,
                            yValueMapper: (WeightData data, _) => data.y)
                      ],
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        header: "Weight",
                        tooltipPosition: TooltipPosition.auto,
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
      height: 230, // Adjusted height relative to screen width
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
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            quote,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget ptrecordswidget() {
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
                  'PT RECORDS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0, // Text size
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
        DateTime startDate =
            currentDate.subtract(Duration(days: 1)); // Start from yesterday

        return SizedBox(
          height: height * 0.3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              DateTime today = startDate.add(Duration(days: index));
              bool isCurrentDate = DateFormat('yyyy-MM-dd').format(today) ==
                  DateFormat('yyyy-MM-dd').format(currentDate);
              bool isPastDate = today.isBefore(currentDate);

              return Container(
                width: width * 0.2,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: isCurrentDate
                      ? LinearGradient(
                          colors: [
                            Color.fromARGB(255, 5, 151, 49),
                            Color.fromARGB(255, 13, 82, 48)
                          ],
                          begin: Alignment.bottomLeft,
                        )
                      : (isPastDate
                          ? LinearGradient(
                              colors: [Colors.grey, Colors.grey],
                            )
                          : LinearGradient(
                              colors: [Colors.white, Colors.white])),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: isCurrentDate
                      ? () {
                          // Navigate to TodayScreen
                          Get.to(() => TodayScreen());
                        }
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        today.day.toString(),
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: isCurrentDate
                              ? Colors.white
                              : (isPastDate ? Colors.black : Colors.black),
                        ),
                      ),
                      Text(
                        DateFormat.MMM().format(today),
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: isCurrentDate
                              ? Colors.white
                              : (isPastDate ? Colors.black : Colors.black),
                        ),
                      ),
                      Text(
                        DateFormat.E().format(today).toUpperCase(),
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: isCurrentDate
                              ? Colors.white
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
      color: Theme.of(context).primaryColor,
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
                      'Wish You Many Many Returns Of The Day.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/cake.png",
                    height: height * 0.1,
                    width: 100,
                  )
                ],
              ),
              Center(
                child: Text(
                  '- From Admin',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
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
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  // Card 1 (Replace with your actual card widget)
                  SizedBox(
                    width: 160, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text('Title'),
                        subtitle: Text(
                          'Description of Card 1. Replace with a longer description to test height adjustment.',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between cards
                  // Card 2 (Replace with your actual card widget)
                  SizedBox(
                    width: 160, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text('Title'),
                        subtitle: Text('Description of Card 2'),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between cards
                  // Card 3 (Replace with your actual card widget)
                  SizedBox(
                    width: 160, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text('Title'),
                        subtitle: Text('Description of Card 3'),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between cards
                  // Card 4 (Replace with your actual card widget)
                  SizedBox(
                    width: 160, // Adjust the width as needed
                    child: Card(
                      color: Color.fromARGB(
                          35, 248, 245, 245), // Use card color from theme
                      child: ListTile(
                        title: Text('Title'),
                        subtitle: Text('Description of Card 4'),
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
