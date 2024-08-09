import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Exercises',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GymListScreen(),
    );
  }
}

class GymListScreen extends StatefulWidget {
  @override
  _GymListScreenState createState() => _GymListScreenState();
}

class _GymListScreenState extends State<GymListScreen> {
  final List<Map<String, String>> items = [
    {
      'title': 'Plank',
      'subtitle': 'Core strengthening exercise',
      'image': 'assets/downloaded/5.jpg',
      'details':
          'The plank is a core strengthening exercise that targets the abdominal muscles, lower back, and shoulders. It involves maintaining a position similar to a push-up for an extended period...',
      'benefits': 'Improves core stability, posture, and balance.',
      'howToDo':
          'Start in a push-up position, with weight on your forearms. Keep body in a straight line and hold.',
      'whenToDo': 'Perform during core workout sessions.',
      'time': 'Hold as long as you can, aiming for 30-60 seconds per set.',
      'caloriesBurned': '4-6 calories per minute.',
    },
    {
      'title': 'Leg Press',
      'subtitle': 'Leg muscle workout',
      'image': 'assets/downloaded/6.png',
      'details':
          'The leg press is a resistance exercise that targets the quadriceps, hamstrings, and gluteal muscles. It involves pushing a weighted platform away from the body using the legs...',
      'benefits':
          'Builds lower body strength, improves muscle tone, and enhances overall leg power.',
      'howToDo':
          'Sit on the leg press machine with feet shoulder-width apart on the platform. Push the platform away by extending your legs.',
      'whenToDo': 'Include in leg workouts.',
      'time': 'Perform 3 sets of 10-15 repetitions.',
      'caloriesBurned': '5-7 calories per minute.',
    },
    {
      'title': 'Pushup',
      'subtitle': 'Upper body exercise',
      'image': 'assets/downloaded/7.png',
      'details':
          'Push-ups are a fundamental upper body exercise that works the chest, shoulders, and triceps. Start in a plank position with hands slightly wider than shoulder-width apart...',
      'benefits':
          'Builds upper body strength, improves muscular endurance, and enhances body stability.',
      'howToDo':
          'Start in a plank position. Lower your body towards the ground by bending your elbows, then push back up.',
      'whenToDo': 'Include in upper body workouts.',
      'time': 'Perform 3 sets of 10-20 repetitions.',
      'caloriesBurned': '6-8 calories per minute.',
    },
    {
      'title': 'Squats',
      'subtitle': 'Leg and glute exercise',
      'image': 'assets/downloaded/8.png',
      'details':
          'Squats are a compound exercise that targets the quadriceps, hamstrings, glutes, and lower back. Stand with feet shoulder-width apart and lower your body by bending your knees...',
      'benefits':
          'Builds lower body strength, improves mobility, and enhances functional fitness.',
      'howToDo':
          'Stand with feet shoulder-width apart. Lower your body by bending knees and hips, then push through heels to return.',
      'whenToDo': 'Include in leg or full-body workouts.',
      'time': 'Perform 3 sets of 12-15 repetitions.',
      'caloriesBurned': '6-8 calories per minute.',
    },
    {
      'title': 'Triceps',
      'subtitle': 'Arm muscle workout',
      'image': 'assets/downloaded/9.png',
      'details':
          'Triceps exercises focus on strengthening the muscles on the back of the upper arms. Common exercises include triceps dips, pushdowns, and overhead extensions...',
      'benefits': 'Improves arm strength and definition.',
      'howToDo':
          'Perform exercises like dips or pushdowns to target the triceps muscles.',
      'whenToDo': 'Include in arm or upper body workouts.',
      'time': 'Perform 3 sets of 10-15 repetitions per exercise.',
      'caloriesBurned': '4-6 calories per minute.',
    },
    {
      'title': 'Walking Lunges',
      'subtitle': 'Leg workout with balance',
      'image': 'assets/downloaded/5.jpg',
      'details':
          'Walking lunges are excellent for building lower body strength, stability, and balance. Step forward with one leg and lower your body until both knees are bent at 90 degrees...',
      'benefits': 'Enhances leg strength, coordination, and flexibility.',
      'howToDo':
          'Step forward with one leg, lower body until both knees are bent, then step forward with the other leg.',
      'whenToDo': 'Include in leg or full-body workouts.',
      'time': 'Perform 3 sets of 12-15 lunges per leg.',
      'caloriesBurned': '6-8 calories per minute.',
    },
    {
      'title': 'Biceps',
      'subtitle': 'Arm muscle workout',
      'image': 'assets/downloaded/6.png',
      'details':
          'Biceps exercises target the muscles at the front of the upper arms. Common exercises include curls, hammer curls, and concentration curls...',
      'benefits': 'Builds arm strength and definition.',
      'howToDo':
          'Perform exercises like curls or hammer curls to target the biceps.',
      'whenToDo': 'Include in arm or upper body workouts.',
      'time': 'Perform 3 sets of 10-15 repetitions per exercise.',
      'caloriesBurned': '4-6 calories per minute.',
    },
    {
      'title': 'Chest Press',
      'subtitle': 'Chest and arm exercise',
      'image': 'assets/downloaded/7.png',
      'details':
          'The chest press targets the pectoral muscles of the chest, along with the triceps and shoulders. Lie on a bench with a dumbbell or barbell and press the weights upwards...',
      'benefits': 'Builds upper body strength and chest development.',
      'howToDo':
          'Lie on a bench and press weights upwards until arms are fully extended.',
      'whenToDo': 'Include in chest or upper body workouts.',
      'time': 'Perform 3 sets of 10-12 repetitions.',
      'caloriesBurned': '6-8 calories per minute.',
    },
    {
      'title': 'Pull-down',
      'subtitle': 'Back and arm exercise',
      'image': 'assets/downloaded/8.png',
      'details':
          'The pull-down targets the latissimus dorsi muscles of the back, along with the biceps and shoulders. Sit at a pull-down machine and pull the bar towards your chest...',
      'benefits': 'Develops upper body strength and back definition.',
      'howToDo':
          'Pull the bar down towards your chest while engaging your back muscles.',
      'whenToDo': 'Include in back or upper body workouts.',
      'time': 'Perform 3 sets of 10-12 repetitions.',
      'caloriesBurned': '5-7 calories per minute.',
    },
    {
      'title': 'Deadlifts',
      'subtitle': 'Full body strength exercise',
      'image': 'assets/downloaded/9.png',
      'details':
          'Deadlifts target multiple muscle groups including the lower back, glutes, hamstrings, and core. Stand with feet hip-width apart and lift a barbell from the floor...',
      'benefits': 'Builds overall strength and enhances functional fitness.',
      'howToDo':
          'Lift a barbell from the floor by extending your hips and knees until standing upright.',
      'whenToDo': 'Include in strength training workouts.',
      'time': 'Perform 3 sets of 8-12 repetitions.',
      'caloriesBurned': '7-10 calories per minute.',
    },
    {
      'title': 'Overhead Press',
      'subtitle': 'Shoulder strength exercise',
      'image': 'assets/downloaded/5.jpg',
      'details':
          'The overhead press focuses on the shoulder muscles, along with the triceps and upper chest. Stand with weights at shoulder height and press upwards...',
      'benefits': 'Develops shoulder strength and upper body power.',
      'howToDo':
          'Press weights overhead from shoulder height until arms are fully extended.',
      'whenToDo': 'Include in shoulder or upper body workouts.',
      'time': 'Perform 3 sets of 10-12 repetitions.',
      'caloriesBurned': '6-8 calories per minute.',
    },
    {
      'title': 'Pull-ups',
      'subtitle': 'Back and arm strength exercise',
      'image': 'assets/downloaded/6.png',
      'details':
          'Pull-ups target the latissimus dorsi muscles of the back, along with the biceps and shoulders. Hang from a bar and pull your body up towards the bar...',
      'benefits': 'Builds upper body strength and back definition.',
      'howToDo':
          'Pull your body up towards the bar by engaging your back and arm muscles.',
      'whenToDo': 'Include in back or upper body workouts.',
      'time': 'Perform 3 sets of 5-10 repetitions.',
      'caloriesBurned': '7-10 calories per minute.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return DetailScreen(item: item);
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']!),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.purple])),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.contain,
                        height: 250,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  item['title']!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  item['subtitle']!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.info_outline,
                  title: 'Details',
                  content: item['details']!,
                ),
                SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.star,
                  title: 'Benefits',
                  content: item['benefits']!,
                ),
                SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.directions_run,
                  title: 'How To Do It',
                  content: item['howToDo']!,
                ),
                SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.schedule,
                  title: 'When To Do It',
                  content: item['whenToDo']!,
                ),
                SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.timer,
                  title: 'Time To Do It',
                  content: item['time']!,
                ),
                SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.local_fire_department,
                  title: 'Calories Burned',
                  content: item['caloriesBurned']!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required IconData icon,
      required String title,
      required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30, color: Colors.blueGrey),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
