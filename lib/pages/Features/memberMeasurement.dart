import 'package:ezeeclub/consts/userLogin.dart';
import 'package:flutter/material.dart';
import '../../controllers/measurementController.dart';
import '../../models/measurement.dart';

class MeasurementView extends StatefulWidget {
  @override
  _MeasurementViewState createState() => _MeasurementViewState();
}

class _MeasurementViewState extends State<MeasurementView> {
  late Future<List<Measurement>> futureMeasurements;
  final MeasurementController _controller = MeasurementController();
  List<Measurement> _measurements = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String member_no = "";
  String BranchNo = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      UserLogin userLogin = UserLogin();
      String? memberNo = await userLogin.getMemberNo();
      String? branchNo = await userLogin.getBranchNo();

      setState(() {
        member_no = memberNo ?? ""; // Default to empty string if null
        BranchNo = branchNo ?? ""; // Default to empty string if null
      });

      // Fetch health details after loading user data
      _fetchMeasurements(member_no, BranchNo);
    } catch (e) {
      // Handle any errors that occur during user data loading
      print('Error loading user data: $e');
    }
  }

  void _fetchMeasurements(String member_no, String branchNo) async {
    try {
      final measurements =
          await _controller.getMeasurementDetails(member_no, branchNo);
      setState(() {
        _measurements = measurements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurement Details', style: TextStyle(fontSize: 24)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('Error: $_errorMessage'))
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.purple.shade400.withOpacity(0.5),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ListView(
                    children: [
                      _buildCategoryCard('Personal Information', [
                        'Activity: ${_measurements[0].activity ?? 'N/A'}',
                        'Age: ${_measurements[0].age ?? 'N/A'}',
                        'EmpName: ${_measurements[0].empName ?? 'N/A'}',
                        'EmpNo: ${_measurements[0].empNo ?? 'N/A'}',
                        'MemberName: ${_measurements[0].memberName ?? 'N/A'}',
                        'MemberNo: ${_measurements[0].memberNo ?? 'N/A'}',
                        'MemberNoBr: ${_measurements[0].memberNoBr ?? 'N/A'}',
                      ]),
                      _buildCategoryCard('Body Measurements', [
                        'HeightInches: ${_measurements[0].heightInches ?? 'N/A'}',
                        'Weight: ${_measurements[0].weight ?? 'N/A'}',
                        'Waist: ${_measurements[0].waist ?? 'N/A'}',
                        'Hip: ${_measurements[0].hip ?? 'N/A'}',
                        'ChestNormal: ${_measurements[0].chestNormal ?? 'N/A'}',
                        'ChstExpanded: ${_measurements[0].chstExpanded ?? 'N/A'}',
                        'Neck: ${_measurements[0].neck ?? 'N/A'}',
                        'Calf: ${_measurements[0].calf ?? 'N/A'}',
                        'Thigh: ${_measurements[0].thigh ?? 'N/A'}',
                        'Forearm: ${_measurements[0].forearm ?? 'N/A'}',
                        'UpperAbdomen: ${_measurements[0].upperAbdomen ?? 'N/A'}',
                        'LowerAbdomen: ${_measurements[0].lowerAbdomen ?? 'N/A'}',
                        'Arms: ${_measurements[0].arms ?? 'N/A'}',
                        'BodyFat: ${_measurements[0].bodyFat ?? 'N/A'}',
                        'BodyWater: ${_measurements[0].bodyWater ?? 'N/A'}',
                        'BoneMass: ${_measurements[0].boneMass ?? 'N/A'}',
                      ]),
                      _buildCategoryCard('Body Composition', [
                        'BMI: ${_measurements[0].bmi ?? 'N/A'}',
                        'BMR: ${_measurements[0].bmr ?? 'N/A'}',
                        'MuscleMass: ${_measurements[0].muscleMass ?? 'N/A'}',
                        'VisceralFat: ${_measurements[0].visceralFat ?? 'N/A'}',
                        'IdealBodyFat: ${_measurements[0].idealBodyFat ?? 'N/A'}',
                        'SekelArms: ${_measurements[0].sekelArms ?? 'N/A'}',
                        'SekelLegs: ${_measurements[0].sekelLegs ?? 'N/A'}',
                        'SekelTrunk: ${_measurements[0].sekelTrunk ?? 'N/A'}',
                        'SekelWholeBody: ${_measurements[0].sekelWholeBody ?? 'N/A'}',
                        'SubcuArms: ${_measurements[0].subcuArms ?? 'N/A'}',
                        'SubcuLegs: ${_measurements[0].subcuLegs ?? 'N/A'}',
                        'SubcuTrunks: ${_measurements[0].subcuTrunks ?? 'N/A'}',
                        'SubcuWholeBody: ${_measurements[0].subcuWholeBody ?? 'N/A'}',
                      ]),
                      _buildCategoryCard('Additional Details', [
                        'BranchName: ${_measurements[0].branchName ?? 'N/A'}',
                        'DietRecall: ${_measurements[0].dietRecall ?? 'N/A'}',
                        'MeasurementDate: ${_measurements[0].measurementDate ?? 'N/A'}',
                        'MeasurementNo: ${_measurements[0].measurementNo ?? 'N/A'}',
                        'PhysiqueRating: ${_measurements[0].physiqueRating ?? 'N/A'}',
                        'Remark: ${_measurements[0].remark ?? 'N/A'}',
                        'WaterIntake: ${_measurements[0].waterIntake ?? 'N/A'}',
                        'HoursTosleep: ${_measurements[0].hoursToSleep ?? 'N/A'}',
                        'WHR: ${_measurements[0].whr ?? 'N/A'}',
                      ]),
                      _buildCategoryCard('Biochemical Parameters', [
                        'BiochemPara: ${_measurements[0].biochemPara ?? 'N/A'}',
                      ]),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCategoryCard(String title, List<String> items) {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ...items.map((item) => Text(
                  item,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
