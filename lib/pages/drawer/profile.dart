import 'package:flutter/material.dart';
import 'package:ezeeclub/controllers/planDetailsController.dart';
import 'package:ezeeclub/models/User.dart';
import 'package:ezeeclub/pages/Features/resetPasswordMember.dart';
import 'package:flip_card/flip_card.dart'; // Import flip_card package
import '../../models/Plan.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const ProfileScreen({super.key, required this.userModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Plan? _plan;
  Plandetailscontroller _planController = Plandetailscontroller();
  String endate = "20/01/2024";

  @override
  void initState() {
    super.initState();
    _fetchPlan();
  }

  void _fetchPlan() async {
    try {
      final plan = await _planController.getPlanDetails(
          widget.userModel.member_no, widget.userModel.BranchNo);
      setState(() {
        _plan = plan;
        if (_plan?.endDt != null) {
          endate = _plan!.endDt;
        } else {
          endate = "20/01/2024";
        }
        // Default value or handle null case
        print(endate);
        print(_plan?.endDt);
      });
    } catch (e) {
      // Handle error - show snackbar or message to the user
      print('Error fetching plan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check Your Internet Connection....'),
        ),
      );
    }

    print(_plan?.endDt.runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0.9),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ResetPasswordMember(
                      memberNo: widget.userModel.member_no,
                      BranchNo: widget.userModel.BranchNo,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.lock),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double fontSize = 18.0;
          if (constraints.maxWidth < 320) {
            fontSize = 16.0;
          } else if (constraints.maxWidth <= 420) {
            fontSize = 18.0;
          } else {
            fontSize = 20.0;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      "assets/user123.png",
                      color:Colors.white,
                      fit: BoxFit.contain,
                    ),
                  
                  SizedBox(height: 20),
                  _buildBasicCard(fontSize),
                  _buildPlanDetailsCard(fontSize),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: ProfileDetail(
                        title: "Email",
                        value: widget.userModel.email ?? "Not Available",
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileDetail(
                            title: "Mobile Number",
                            value:
                                widget.userModel.phoneNumber ?? "Not Available",
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileDetail(
                            title: "Location",
                            value: widget.userModel.location ?? "Not Available",
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: widget.userModel.mem_status == "Active"
                        ? Card(
                            color: Colors.green,
                            child: ProfileDetail(
                              title: "Membership Status ",
                              value: widget.userModel.mem_status,
                              fontSize: fontSize,
                            ),
                          )
                        : Card(
                            color: Colors.red,
                            child: ProfileDetail(
                              title: "Membership Status ",
                              value: widget.userModel.mem_status,
                              fontSize: fontSize,
                            ),
                          ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDateString(String dateString) {
    List<String> parts = dateString.split('/');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  Widget _buildBasicCard(double fontSize) {
    DateTime? targetDate;
    print("end date is :${endate.runtimeType}");
    if (endate == "") {
      targetDate = DateTime.tryParse(_formatDateString("20/1/2024"));
    } else {
      targetDate = DateTime.tryParse(_formatDateString(endate));
    }

    DateTime now = DateTime.now();
    int differenceInDays = targetDate?.difference(now).inDays ?? 0;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [
                  Colors.black.withOpacity(1),
                  Colors.purple.shade800,
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 16, offset: Offset.zero)
              ]),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Expanded(
                    child: Text(
                      'Gym Member Card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Text(
                'Name',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                widget.userModel.fullName ?? "Not Available",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Member Number',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        "***** ${widget.userModel.member_no}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Expiry Date',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        _plan?.endDt ?? "Not Available",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      differenceInDays > 0
                          ? Text(
                              "Expires in $differenceInDays Days",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoPlanDetailsCard(double fontSize) {
    return Card(
      child: Center(
        child: Text(
          'Plan Details Not Found.',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }

  Widget _buildPlanDetailsCard(double fontSize) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ProfileDetail(
                    title: "Program",
                    value: _plan?.programName ?? "Not Available",
                    fontSize: fontSize,
                                            ),
                   
                  ],
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ProfileDetail(
                    title: "Plan",
                    value: _plan?.planName ?? "Not Available",
                    fontSize: fontSize,
                                            ),
                   
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          ProfileDetail(
                            title: "Start Date",
                            value: _plan?.startDt ?? "Not Available",
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16), // Adjust spacing between columns
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          ProfileDetail(
                            title: "End Date",
                            value: _plan?.endDt ?? "Not Available",
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ProfileDetail(
                  title: "Amount Paid",
                  value: _plan?.paidAmount ?? "Not Available",
                  fontSize: fontSize,
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  }

class ProfileDetail extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;

  const ProfileDetail({
    super.key,
    required this.title,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : "Not Available",
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
