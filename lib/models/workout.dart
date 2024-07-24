import 'dart:convert';

class WorkoutDetails {
  String? areaOfConcern;
  String? bodyPart;
  String? branchNo;
  String? cooldown;
  String? day;
  String? exercise;
  String? instructor;
  String? instructorNo;
  String? memberNo;
  String? planEnd;
  String? planSelectionNo;
  String? planStart;
  String? remark;
  String? warmup;
  String? workoutFrom;
  String? workoutNo;
  String? workoutTo;
  int? reps;
  int? sets;

  WorkoutDetails({
    this.areaOfConcern,
    this.bodyPart,
    this.branchNo,
    this.cooldown,
    this.day,
    this.exercise,
    this.instructor,
    this.instructorNo,
    this.memberNo,
    this.planEnd,
    this.planSelectionNo,
    this.planStart,
    this.remark,
    this.warmup,
    this.workoutFrom,
    this.workoutNo,
    this.workoutTo,
    this.reps,
    this.sets,
  });

  factory WorkoutDetails.fromJson(Map<String, dynamic> json) => WorkoutDetails(
        areaOfConcern: json['AreaOfConcern'],
        bodyPart: json['BodyPart'],
        branchNo: json['BranchNo'],
        cooldown: json['Cooldown'],
        day: json['Day'],
        exercise: json['Excersize'],
        instructor: json['Instructor'],
        instructorNo: json['InstructorNo'],
        memberNo: json['MemberNo'],
        planEnd: json['PlanEnd'],
        planSelectionNo: json['PlanSelectionNo'],
        planStart: json['PlanStart'],
        remark: json['Remark'],
        warmup: json['Warmup'],
        workoutFrom: json['WorkoutFrom'],
        workoutNo: json['WorkoutNo'],
        workoutTo: json['WorkoutTo'],
        reps: json['reps'],
        sets: json['sets'],
      );

  Map<String, dynamic> toJson() => {
        'AreaOfConcern': areaOfConcern,
        'BodyPart': bodyPart,
        'BranchNo': branchNo,
        'Cooldown': cooldown,
        'Day': day,
        'Excersize': exercise,
        'Instructor': instructor,
        'InstructorNo': instructorNo,
        'MemberNo': memberNo,
        'PlanEnd': planEnd,
        'PlanSelectionNo': planSelectionNo,
        'PlanStart': planStart,
        'Remark': remark,
        'Warmup': warmup,
        'WorkoutFrom': workoutFrom,
        'WorkoutNo': workoutNo,
        'WorkoutTo': workoutTo,
        'reps': reps,
        'sets': sets,
      };
}

// Example of usage:
void main() {
  // JSON string representing data
  String jsonString = '''
  {
    "AreaOfConcern": null,
    "BodyPart": null,
    "BranchNo": null,
    "Cooldown": null,
    "Day": null,
    "Excersize": null,
    "Instructor": null,
    "InstructorNo": null,
    "MemberNo": null,
    "PlanEnd": null,
    "PlanSelectionNo": null,
    "PlanStart": null,
    "Remark": null,
    "Warmup": null,
    "WorkoutFrom": null,
    "WorkoutNo": 1,
    "WorkoutTo": null,
    "reps": null,
    "sets": null
  }
  ''';

  // Parse JSON string to a Map
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  // Convert Map to WorkoutDetails object
  WorkoutDetails workoutDetails = WorkoutDetails.fromJson(jsonMap);

  // Access properties
  print(workoutDetails.workoutNo); // Output: 1

  // Convert WorkoutDetails object back to JSON string
  String jsonOutput = jsonEncode(workoutDetails.toJson());

  // Print JSON output
  print(jsonOutput);
}
