import 'package:ezeeclub/consts/userLogin.dart';
import 'package:flutter/material.dart';
import 'package:ezeeclub/controllers/dietplanController.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/models/dietplanmodel.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  Dietplan? dietplan;
  String member_no = "";
  String branchno = "";
  @override
  void initState() {
    super.initState();
    loaddata();
  }

  Future<void> loaddata() async {
    UserLogin userLogin = UserLogin();
    String? memberno = await userLogin.getMemberNo();
    String? BranchNo = await userLogin.getBranchNo();
    setState(() {
      member_no = memberno ?? ""; // Update the state
      branchno = BranchNo ?? "";
    });
    getDietPlan(member_no, branchno);
  }

  void getDietPlan(String member_no, branchno) async {
    try {
      Dietplan? fetchedPlan =
          await Dietplancontroller().getdietplan(member_no, branchno);
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
