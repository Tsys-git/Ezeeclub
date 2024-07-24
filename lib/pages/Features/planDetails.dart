import 'package:flutter/material.dart';
import 'package:ezeeclub/controllers/planDetailsController.dart';
import '../../models/Plan.dart';

class PlanDetailsPage extends StatefulWidget {
  final String member_no;
  final String branchNo;

  const PlanDetailsPage({
    super.key,
    required this.member_no,
    required this.branchNo,
  });

  @override
  _PlanDetailsPageState createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage> {
  Plan? _plan;

  final Plandetailscontroller _planController = Plandetailscontroller();

  @override
  void initState() {
    super.initState();
    _plan = null;
    _fetchPlan();
  }

  void _fetchPlan() async {
    try {
      final plan = await _planController.getPlanDetails(
          widget.member_no, widget.branchNo);
      setState(() {
        _plan = plan;
        print(_plan);
      });
    } catch (e) {
      // Handle error
      print('Error fetching plan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Details', style: TextStyle(fontSize: 24)),
      ),
      body: Center(
        child: _plan != null
            ? ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.white),
                    title: Text('Member Name'),
                    subtitle: Text(_plan!.memberName),
                  ),
                  ListTile(
                    leading: Icon(Icons.event, color: Colors.white),
                    title: Text('Joining Date'),
                    subtitle: Text(_plan!.joiningDate),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.receipt_long_rounded, color: Colors.white),
                    title: Text('Plan Name '),
                    subtitle: Text("${_plan!.planName} ( ${_plan!.planNo} )"),
                  ),
                  ListTile(
                    leading: Icon(Icons.sports_gymnastics_sharp,
                        color: Colors.white),
                    title: Text('Program Name'),
                    subtitle: Text(_plan!.programName),
                  ),

                  ListTile(
                    leading: Icon(Icons.event, color: Colors.white),
                    title: Text('Start Date'),
                    subtitle: Text(_plan!.startDt),
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range, color: Colors.white),
                    title: Text('End Date'),
                    subtitle: Text(_plan!.endDt),
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on, color: Colors.white),
                    title: Text('Paid Amount'),
                    subtitle: Text(_plan!.paidAmount),
                  ),

                  // Add more ListTiles for other plan details
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
