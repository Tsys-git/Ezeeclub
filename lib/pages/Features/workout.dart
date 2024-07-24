import 'package:flutter/material.dart';
import 'package:ezeeclub/controllers/workoutDetailsController.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/models/workout.dart';

class workoutScreen extends StatefulWidget {
  final UserModel userModel;
  const workoutScreen({super.key, required this.userModel});

  @override
  State<workoutScreen> createState() => _workoutScreenState();
}

class _workoutScreenState extends State<workoutScreen> {

  WorkoutDetails? workoutDetails;

  @override
  void initState() {
    super.initState();
    workoutDetails = null;
    fetchWorkOutDetails();
  }

  

  void fetchWorkOutDetails() async {
    try {
      final workoutData = await WorkoutDetailsController().getWorkoutDetails(
        widget.userModel.member_no,
        widget.userModel.BranchNo,
      );
      setState(() {
        workoutDetails = workoutData;
      });
    } catch (e) {
      print('Error fetching workout details: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workout Details Screen",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Center(
        child: workoutDetails != null
            ? SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.interests),
                          title: Text("Area Of Concern"),
                          subtitle: Text(
                              workoutDetails!.areaOfConcern ?? "Not Mentioned"),
                        ),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Member No"),
                          subtitle: Text(workoutDetails!.branchNo ??
                              widget.userModel.member_no.toString()),
                        ),
                        ListTile(
                          leading: Icon(Icons.business_outlined),
                          title: Text("Branch No"),
                          subtitle: Text(workoutDetails!.branchNo ??
                              widget.userModel.BranchNo.toString()),
                        ),
                        ListTile(
                          leading: Text(workoutDetails!.instructorNo ?? "NA"),
                          title: Text("Instructor Name"),
                          subtitle: Text(
                              workoutDetails!.instructor ?? "Not Available"),
                        ),
                        ListTile(
                          leading: Icon(Icons.date_range_outlined),
                          title: Text("Workout Dates"),
                          subtitle: Text(
                            workoutDetails!.workoutFrom != null &&
                                    workoutDetails!.workoutTo != null
                                ? "${workoutDetails!.workoutFrom} - ${workoutDetails!.workoutTo}"
                                : "Not Available",
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Workout Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildDetailRow(
                          label: "Body Part",
                          value: workoutDetails!.bodyPart ?? "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Exercise",
                          value: workoutDetails!.exercise ?? "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Reps",
                          value: workoutDetails!.reps?.toString() ??
                              "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Sets",
                          value: workoutDetails!.sets?.toString() ??
                              "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Plan Start",
                          value: workoutDetails!.planStart ?? "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Plan End",
                          value: workoutDetails!.planEnd ?? "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Day",
                          value: workoutDetails!.day ?? "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Workout No",
                          value: workoutDetails!.workoutNo?.toString() ??
                              "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Remark",
                          value: workoutDetails!.remark?.toString() ??
                              "Not Available",
                        ),
                        _buildDetailRow(
                          label: "Warm Up",
                          value: workoutDetails!.warmup?.toString() ??
                              "Not Available",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildInstructorDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.person_4_outlined),
            SizedBox(width: 10),
            Text("Instructor Details", style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Instructor", style: TextStyle(fontSize: 20)),
            Text("Instructor No", style: TextStyle(fontSize: 20)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(workoutDetails!.instructor ?? "Not Available"),
            Text(workoutDetails!.instructorNo ?? "Not Available"),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkoutDates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.calendar_month),
            SizedBox(width: 10),
            Text('Work out Dates', style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Workout From", style: TextStyle(fontSize: 20)),
            Text("Workout To", style: TextStyle(fontSize: 20)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(workoutDetails!.workoutFrom ?? "Not Available"),
            Text(workoutDetails!.workoutTo ?? "Not Available"),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
