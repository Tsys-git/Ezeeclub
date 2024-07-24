class PTSession {
  final String? allocID;
  final String? empNo;
  final String? memberName;
  final String? memberNo;
  final String? noOfSessions;
  final String? planName;
  final String? recNo; // Assuming RecNo is always a String
  final String? sessionDate;
  final String? trainerName;

  PTSession({
    this.allocID,
    this.empNo,
    this.memberName,
    this.memberNo,
    this.noOfSessions,
    this.planName,
    this.recNo,
    this.sessionDate,
    this.trainerName,
  });

  factory PTSession.fromJson(Map<String, dynamic> json) {
    return PTSession(
      allocID: json['AllocID'],
      empNo: json['EmpNo'],
      memberName: json['MemberName'],
      memberNo: json['MemberNo'],
      noOfSessions: json['NoOfSessions'],
      planName: json['PlanName'],
      recNo: json['RecNo'] ?? 'No', // Default value 'No' if not present
      sessionDate: json['SessionDate'],
      trainerName: json['TrainerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AllocID': allocID,
      'EmpNo': empNo,
      'MemberName': memberName,
      'MemberNo': memberNo,
      'NoOfSessions': noOfSessions,
      'PlanName': planName,
      'RecNo': recNo,
      'SessionDate': sessionDate,
      'TrainerName': trainerName,
    };
  }
}
