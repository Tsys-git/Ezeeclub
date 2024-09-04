import 'package:ezeeclub/consts/userLogin.dart';
import 'package:ezeeclub/models/PTSessionModel.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/Features/slotBooking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/ptsessionController.dart';

class PTRecords extends StatefulWidget {
  const PTRecords({
    super.key,
  });

  @override
  State<PTRecords> createState() => _PTRecordsState();
}

class _PTRecordsState extends State<PTRecords> {
  List<PTSession> ptSessions = [];
  String member_no = "";
  String branchno = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  Future<void> loaddata() async {
    UserLogin userLogin = UserLogin();
    String? memberno = await userLogin.getMemberNo();
    String? BranchNo = await userLogin.getBranchNo();

    String? Name = await userLogin.getName();
    setState(() {
      member_no = memberno ?? ""; // Update the state
      branchno = BranchNo ?? "";
      name = Name ?? "";
    });
    fetchPTSessions(member_no, branchno);
  }

  void fetchPTSessions(String memberNo, String branchno) async {
    try {
      List<PTSession> fetchedSessions =
          await PTSessionController().getPTSessions(memberNo, branchno);
      setState(() {
        ptSessions = fetchedSessions;
      });

      print(ptSessions);
    } catch (e) {
      // Handle error gracefully
      print('Error fetching PT sessions: $e');
      setState(() {
        ptSessions = []; // Reset sessions to an empty list if fetching fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PT Records', style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        children: [
          Expanded(
            child: 
                ListView.builder(
                    itemCount: ptSessions.length,
                    itemBuilder: (context, index) {
                      return _buildPTSessionCard(ptSessions[index]);
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => SlotBooking());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Slot Booking"),
          ),
        ],
      ),
    );
  }

  Widget _buildPTSessionCard(PTSession session) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(name),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plan: ${session.planName ?? 'No Plan'}'),
              SizedBox(height: 10),
              Text('Trainer: ${session.trainerName ?? 'No Trainer'}'),
              SizedBox(height: 10),
              Text('Sessions: ${session.noOfSessions ?? "0"}'),
              SizedBox(height: 10),
              Text('Session Date: ${session.sessionDate ?? 'Not Mentioned'}'),
              SizedBox(height: 10),
              Text('RecNo: ${session.recNo}'),
            ],
          ),
        ),
      ),
    );
  }
}
