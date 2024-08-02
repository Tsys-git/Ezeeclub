import 'package:flutter/material.dart';

class GymListScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'title': 'Plank',
      'subtitle': 'Core strengthening exercise',
      'image': 'assets/downloaded/5.jpg',
      'details':
          'The plank is a core strengthening exercise that targets the abdominal muscles, lower back, and shoulders. It involves maintaining a position similar to a push-up for an extended period. To perform a plank, start in a push-up position, but with your weight on your forearms instead of your hands. Keep your body in a straight line from head to heels, engaging your core muscles. Hold this position as long as you can. Planks are excellent for improving core stability, posture, and balance. They also help build endurance in the back, chest, and shoulders. Regular practice can contribute to better overall strength and can assist in reducing back pain. Incorporate planks into your routine for a full-body workout that enhances core strength and supports functional movements.'
    },
    {
      'title': 'Leg Press',
      'subtitle': 'Leg muscle workout',
      'image': 'assets/downloaded/6.png',
      'details':
          'The leg press is a resistance exercise that targets the quadriceps, hamstrings, and gluteal muscles. It involves pushing a weighted platform away from the body using the legs. To perform the leg press, sit on the leg press machine with your back supported and feet placed shoulder-width apart on the platform. Push the platform away by extending your legs, then slowly return to the starting position. The leg press helps in building lower body strength, improving muscle tone, and enhancing overall leg power. It is a great alternative to squats for those who have joint issues or prefer machine-based exercises. Regular leg press exercises can help in developing stronger legs, improving athletic performance, and increasing lower body endurance.'
    },
    {
      'title': 'Pushup',
      'subtitle': 'Upper body exercise',
      'image': 'assets/downloaded/7.png',
      'details':
          'Push-ups are a fundamental upper body exercise that works the chest, shoulders, and triceps. To perform a push-up, start in a plank position with your hands slightly wider than shoulder-width apart. Lower your body towards the ground by bending your elbows until your chest almost touches the floor. Push yourself back up to the starting position. Push-ups can be modified to increase or decrease difficulty, such as by elevating the feet or performing them on the knees. Regular push-ups help in building upper body strength, improving muscular endurance, and enhancing overall body stability. They are a versatile exercise that can be performed anywhere with no equipment needed.'
    },
    {
      'title': 'Squats',
      'subtitle': 'Leg and glute exercise',
      'image': 'assets/downloaded/8.png',
      'details':
          'Squats are a compound exercise that targets the quadriceps, hamstrings, glutes, and lower back. To perform a squat, stand with your feet shoulder-width apart and your toes slightly pointed outward. Lower your body by bending your knees and hips, keeping your back straight and chest up. Go down as far as you can while maintaining good form, then push through your heels to return to the starting position. Squats are effective for building lower body strength, improving mobility, and enhancing overall functional fitness. They can be performed with body weight or added resistance such as dumbbells or a barbell. Regular squatting helps in developing powerful legs and a strong core.'
    },
    {
      'title': 'Triceps',
      'subtitle': 'Arm muscle workout',
      'image': 'assets/downloaded/9.png',
      'details':
          'Triceps exercises focus on strengthening the muscles on the back of the upper arms. These exercises are essential for building arm strength and definition. Common triceps exercises include triceps dips, triceps pushdowns, and overhead triceps extensions. To perform a triceps dip, support yourself on a bench or parallel bars with your hands, and lower your body by bending your elbows, then push yourself back up. Triceps exercises help in improving arm endurance, enhancing upper body strength, and contributing to a balanced physique. They are crucial for any upper body workout routine and can be combined with other exercises for a comprehensive arm workout.'
    },
    {
      'title': 'Walking Lunges',
      'subtitle': 'Leg workout with balance',
      'image': 'assets/downloaded/5.jpg',
      'details':
          'Walking lunges are an excellent exercise for building lower body strength, stability, and balance. To perform walking lunges, step forward with one leg and lower your body until both knees are bent at approximately 90 degrees. Push off the back foot and step forward with the other leg into the next lunge. Repeat this movement, walking forward with each lunge. Walking lunges target the quadriceps, hamstrings, glutes, and calves while also engaging the core for balance. They are effective for improving leg strength, enhancing coordination, and increasing flexibility. Incorporate walking lunges into your routine for a dynamic and functional lower body workout.'
    },
    {
      'title': 'Biceps',
      'subtitle': 'Arm muscle workout',
      'image': 'assets/downloaded/6.png',
      'details':
          'Biceps exercises are designed to target the muscles at the front of the upper arms. Common exercises include bicep curls, hammer curls, and concentration curls. To perform a basic bicep curl, hold a dumbbell in each hand with your arms fully extended and palms facing forward. Curl the weights up towards your shoulders by bending your elbows, then slowly lower them back to the starting position. Biceps exercises help in building arm strength, improving muscle definition, and enhancing overall upper body aesthetics. They are essential for achieving well-rounded arm development and can be included in any upper body strength training routine.'
    },
    {
      'title': 'Chest Press',
      'subtitle': 'Chest and arm exercise',
      'image': 'assets/downloaded/7.png',
      'details':
          'The chest press is a resistance exercise that primarily targets the pectoral muscles of the chest, along with the triceps and shoulders. To perform a chest press, lie on a bench with a dumbbell or barbell in each hand. Press the weights upwards until your arms are fully extended, then lower them back down to chest level. The chest press can be done on a flat, incline, or decline bench to target different parts of the chest. This exercise helps in building upper body strength, improving muscular endurance, and enhancing overall chest development. It is a fundamental exercise for any chest workout routine and can be adjusted for various fitness levels.'
    },
    {
      'title': 'Pull-down',
      'subtitle': 'Back and arm exercise',
      'image': 'assets/downloaded/8.png',
      'details':
          'The pull-down is a strength training exercise that targets the latissimus dorsi muscles of the back, along with the biceps and shoulders. To perform a pull-down, sit at a pull-down machine and grasp the bar with a wide grip. Pull the bar down towards your chest by engaging your back muscles and bending your elbows, then slowly return to the starting position. Pull-downs are effective for developing upper body strength, improving back definition, and enhancing overall pulling power. This exercise can be modified by adjusting the grip or using different attachments to target various areas of the back and arms. Regular pull-downs contribute to a balanced and strong upper body.'
    },
    {
      'title': 'Deadlifts',
      'subtitle': 'Full body strength exercise',
      'image': 'assets/downloaded/9.png',
      'details':
          'Deadlifts are a compound exercise that targets multiple muscle groups, including the lower back, glutes, hamstrings, and core. To perform a deadlift, stand with your feet hip-width apart and a barbell on the floor in front of you. Bend at the hips and knees to grasp the barbell with an overhand grip. Lift the barbell by extending your hips and knees until you are standing upright, then lower it back to the floor. Deadlifts are highly effective for building overall strength, improving posture, and enhancing functional fitness. They are a fundamental exercise for any strength training program and can be performed with variations such as sumo or Romanian deadlifts for different muscle emphasis.'
    },
    {
      'title': 'Overhead Press',
      'subtitle': 'Shoulder strength exercise',
      'image': 'assets/downloaded/5.jpg',
      'details':
          'The overhead press is a strength exercise that focuses on the shoulder muscles, along with the triceps and upper chest. To perform the overhead press, stand with your feet shoulder-width apart and hold a barbell or dumbbells at shoulder height. Press the weights overhead by extending your arms, then lower them back down to shoulder level. This exercise helps in developing shoulder strength, improving muscle definition, and enhancing upper body power. Variations of the overhead press include seated or standing presses, and you can adjust the grip to target different parts of the shoulders. Incorporate the overhead press into your routine to build a strong and balanced upper body.'
    },
    {
      'title': 'Pull-ups',
      'subtitle': 'Back and arm strength exercise',
      'image': 'assets/downloaded/6.png',
      'details':
          'Pull-ups are an upper body exercise that targets the latissimus dorsi muscles of the back, along with the biceps and shoulders. To perform a pull-up, grasp a pull-up bar with an overhand grip and hang with your arms fully extended. Pull your body up towards the bar by engaging your back and arm muscles, then lower yourself back to the starting position. Pull-ups are excellent for building upper body strength, improving back definition, and enhancing grip strength. They can be modified by using different grips or adding weight for increased difficulty. Incorporating pull-ups into your workout routine can help develop a strong and well-defined back and arms.'
    },
    {
      'title': 'Strength Training',
      'subtitle': 'Building muscle strength',
      'image': 'assets/downloaded/7.png',
      'details':
          'Strength training involves performing exercises that improve muscle strength and endurance by using resistance. This can include weight lifting, bodyweight exercises, and resistance band workouts. The primary goal of strength training is to increase muscle mass, enhance muscular endurance, and improve overall physical fitness. Strength training exercises target various muscle groups and can be customized based on individual fitness goals. Regular strength training helps in boosting metabolism, improving bone density, and supporting joint health. It also plays a crucial role in enhancing athletic performance and overall functional fitness. Incorporate a variety of exercises and progressively increase the resistance to achieve optimal results in strength training.'
    },
    {
      'title': 'Cable Machine',
      'subtitle': 'Versatile gym equipment',
      'image': 'assets/downloaded/8.png',
      'details':
          'The cable machine is a versatile piece of gym equipment that allows for a wide range of exercises targeting different muscle groups. It consists of adjustable cables and pulleys that can be set at various heights and angles. Common exercises performed on the cable machine include cable rows, chest flies, and triceps pushdowns. The cable machine provides constant tension throughout the movement, which can help in improving muscle engagement and enhancing overall strength. It is suitable for both beginners and advanced users and can be used to perform isolation exercises as well as compound movements. Incorporating cable machine exercises into your routine can contribute to balanced muscle development and functional strength.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What To Do Today?'),
      ),
      body: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          index == items.length ? index = 0 : index = index;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: Color.fromARGB(255, 25, 94, 116),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.contain,
                        height: 250,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  item['title']!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  item['subtitle']!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  item['details']!,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
