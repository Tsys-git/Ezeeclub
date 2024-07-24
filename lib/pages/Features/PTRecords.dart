import 'package:ezeeclub/models/PTSessionModel.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:flutter/material.dart';

import '../../controllers/ptsessionController.dart';

class PTRecords extends StatefulWidget {
  final UserModel userModel;
  const PTRecords( {super.key, required this.userModel});

  @override
  State<PTRecords> createState() => _PTRecordsState();
}

class _PTRecordsState extends State<PTRecords> {
  List<PTSession> ptSessions = [];

  @override
  void initState() {
    super.initState();
    fetchPTSessions();
  }

  void fetchPTSessions() async {
    try {
      List<PTSession> fetchedSessions =
          await PTSessionController().getPTSessions(
        widget.userModel.member_no,
        widget.userModel.BranchNo,
      );
      setState(() {
        ptSessions = fetchedSessions;
      });
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
        title: Text('PT Records'),
      ),
      body: ListView.builder(
        itemCount: ptSessions.length,
        itemBuilder: (context, index) {
          return _buildPTSessionCard(ptSessions[index]);
        },
      ),
    );
  }

  Widget _buildPTSessionCard(PTSession session) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(session.memberName ?? widget.userModel.fullName),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plan: ${session.planName ?? 'No Plan'}'),
              SizedBox(
                height: 10,
              ),
              Text('Trainer: ${session.trainerName ?? 'No Trainer'}'),
              SizedBox(
                height: 10,
              ),
              Text('Sessions: ${session.noOfSessions ?? "0"}'),
              SizedBox(
                height: 10,
              ),
              Text('Session Date: ${session.sessionDate ?? 'Not Mentioned'}'),
              SizedBox(
                height: 10,
              ),
              Text('RecNo: ${session.recNo}'),
            ],
          ),
        ),
      ),
    );
  }
}
