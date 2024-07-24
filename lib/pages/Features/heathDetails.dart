import 'package:flutter/material.dart';
import 'package:ezeeclub/controllers/healthDetailsController.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/models/healthRecord.dart';

class HeathdetailsScreen extends StatefulWidget {
  final UserModel userModel;

  const HeathdetailsScreen({super.key, required this.userModel});

  @override
  State<HeathdetailsScreen> createState() => _HeathdetailsScreenState();
}

class _HeathdetailsScreenState extends State<HeathdetailsScreen> {
  HealthDetail? healthDetail;

  @override
  void initState() {
    super.initState();
    healthDetail = null;
    fetchHealthDetails();
  }

  void fetchHealthDetails() async {
    try {
      final healthData = await Healthdetailscontroller().getHealthDetails(
          widget.userModel.member_no, widget.userModel.BranchNo);
      setState(() {
        healthDetail = healthData;
      });
    } catch (e) {
      // Handle error
      print('Error fetching health details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Details', style: TextStyle(fontSize: 24)),
      ),
      body: Center(
        child: healthDetail != null
            ? ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Image.asset("assets/man.png"),
                  _buildSectionCard(
                    title: 'General Details',
                    children: [
                      _buildListTile(
                        'Member No',
                        healthDetail!.memberNo ?? widget.userModel.member_no,
                      ),
                      _buildListTile(
                        'Branch No',
                        healthDetail!.branchNo ?? widget.userModel.BranchNo,
                      ),
                      _buildListTile(
                        'Health Detail No',
                        healthDetail!.healthDetailNo,
                      ),
                      _buildListTile(
                        'Health Detail Date',
                        healthDetail!.healthDetailDate,
                      ),
                      _buildListTile(
                        'Trainer',
                        healthDetail!.trainer,
                      ),
                    ],
                  ),
                  _buildSectionCard(
                    title: 'Physical Conditions',
                    children: [
                      _buildListTile(
                        'Alimentary Test Ailments',
                        healthDetail!.alimentaryTestAilments,
                      ),
                      _buildListTile(
                        'Asthma',
                        healthDetail!.asthma,
                      ),
                      _buildListTile(
                        'BP',
                        healthDetail!.bp,
                      ),
                      _buildListTile(
                        'BP Pulse',
                        healthDetail!.bpPulse,
                      ),
                      _buildListTile(
                        'Back',
                        healthDetail!.back,
                      ),
                      _buildListTile(
                        'Hips',
                        healthDetail!.hips,
                      ),
                      _buildListTile(
                        'Knees',
                        healthDetail!.knees,
                      ),
                      _buildListTile(
                        'Shoulder',
                        healthDetail!.shoulder,
                      ),
                      _buildListTile(
                        'Neck',
                        healthDetail!.neck,
                      ),
                      _buildListTile(
                        'Spondilities',
                        healthDetail!.spondilities,
                      ),
                    ],
                  ),
                  _buildSectionCard(
                    title: 'Medical History',
                    children: [
                      _buildListTile(
                        'Cardiac History',
                        healthDetail!.cardiacHistory,
                      ),
                      _buildListTile(
                        'Diabetes',
                        healthDetail!.dibeties,
                      ),
                      _buildListTile(
                        'Due to Injury',
                        healthDetail!.duetoInjury,
                      ),
                      _buildListTile(
                        'Due to Injury When',
                        healthDetail!.duetoInjuryWhen,
                      ),
                      _buildListTile(
                        'Follow Up',
                        healthDetail!.followUp,
                      ),
                      _buildListTile(
                        'Gynaecological Problems',
                        healthDetail!.gynaecologicalProblems,
                      ),
                      _buildListTile(
                        'Major Injuries',
                        healthDetail!.majorInjuries,
                      ),
                      _buildListTile(
                        'Medical',
                        healthDetail!.medical,
                      ),
                      _buildListTile(
                        'Medical When',
                        healthDetail!.medicalWhen,
                      ),
                      _buildListTile(
                        'Others',
                        healthDetail!.others,
                      ),
                      _buildListTile(
                        'Past',
                        healthDetail!.past,
                      ),
                      _buildListTile(
                        'Present',
                        healthDetail!.present,
                      ),
                      _buildListTile(
                        'Sugar',
                        healthDetail!.sugar,
                      ),
                      _buildListTile(
                        'Surgeries',
                        healthDetail!.surgeries,
                      ),
                      _buildListTile(
                        'Surgical',
                        healthDetail!.surgical,
                      ),
                      _buildListTile(
                        'Surgical When',
                        healthDetail!.surgicalWhen,
                      ),
                      _buildListTile(
                        'Thyroid Function',
                        healthDetail!.thyroidFunction,
                      ),
                    ],
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Center(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String? value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value ?? 'Not Available'),
    );
  }
}
