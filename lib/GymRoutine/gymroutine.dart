
class GymRoutine {
  final String name;
  final String description;

  GymRoutine({
    required this.name,
    required this.description,
  });
}

class GymRoutineData {
  static List<GymRoutine> fourDaySplit = [
    GymRoutine(name: 'Day 1', description: 'Triceps, Chest, Shoulders'),
    GymRoutine(name: 'Day 2', description: 'Back, Biceps'),
    GymRoutine(name: 'Day 3', description: 'Legs, Abs'),
    GymRoutine(name: 'Day 4', description: 'Rest'),
  ];
}
