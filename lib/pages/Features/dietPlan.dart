import 'package:flutter/material.dart';
import 'package:ezeeclub/controllers/dietplanController.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/models/dietplanmodel.dart';

class DietPlanScreen extends StatefulWidget {
  final UserModel userModel;

  const DietPlanScreen({super.key, required this.userModel});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  Dietplan? dietplan;

  @override
  void initState() {
    super.initState();
    getDietPlan();
  }

  void getDietPlan() async {
    try {
      Dietplan? fetchedPlan = await Dietplancontroller().getdietplan(
        widget.userModel.member_no,
        widget.userModel.BranchNo,
      );
      setState(() {
        dietplan = fetchedPlan;
      });
    } catch (e) {
      // Handle error gracefully
      print('Error fetching diet plan: $e');
      setState(() {
        dietplan = null; // Reset dietplan to null if fetching fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diet Plan", style: TextStyle(fontSize: 24)),
      ),
      body: Center(
        child: dietplan != null
            ? _buildDietPlanCard(dietplan!)
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDietPlanCard(Dietplan dietplan) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.restaurant),
          title: Text('Diet Food'),
          subtitle: Text(dietplan.dietFood ?? "Not Available"),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Dietician'),
          subtitle: Text(dietplan.dietician ?? "Not Available"),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text('Diet From Date'),
          subtitle: Text(dietplan.dietFromDate ?? "Not Available"),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text('Diet To Date'),
          subtitle: Text(dietplan.dietToDate ?? "Not Available"),
        ),
        ListTile(
          leading: Icon(Icons.timeline),
          title: Text('Diet Time'),
          subtitle: Text(dietplan.dietTime ?? "Not Available"),
        ),
      ],
    );
  }
}
