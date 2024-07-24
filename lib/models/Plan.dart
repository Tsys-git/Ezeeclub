class Plan {
  final String active;
  final String balanceAmount;
  final String durationMonth;
  final String durationDays;
  final String endDt;
  final String joiningDate;
  final String memberName;
  final String memberNo;
  final String memberNoBr;
  final String mobileNo;
  final String paidAmount;
  final String planName;
  final String planNo;
  final String planSelectionNo;
  final String programName;
  final String renewDate;
  final String saleAmount;
  final String startDt;
  final String isTransfered;

  Plan({
    required this.active,
    required this.balanceAmount,
    required this.durationMonth,
    required this.durationDays,
    required this.endDt,
    required this.joiningDate,
    required this.memberName,
    required this.memberNo,
    required this.memberNoBr,
    required this.mobileNo,
    required this.paidAmount,
    required this.planName,
    required this.planNo,
    required this.planSelectionNo,
    required this.programName,
    required this.renewDate,
    required this.saleAmount,
    required this.startDt,
    required this.isTransfered,
  });
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      active: json['Active'] ?? '', // Use '' as default value if active is null
      balanceAmount: json['BalanceAmount'] ??
          '', // Use '' as default value if balanceAmount is null
      durationMonth: json['DurationMonth'] ??
          '', // Use '' as default value if durationMonth is null
      durationDays: json['DurationDays'] ??
          '', // Use '' as default value if durationDays is null
      endDt: json['EndDt'] ?? '', // Use '' as default value if endDt is null
      joiningDate: json['JoiningDate'] ??
          '', // Use '' as default value if joiningDate is null
      memberName: json['MemberName'] ??
          '', // Use '' as default value if memberName is null
      memberNo:
          json['MemberNo'] ?? '', // Use '' as default value if memberNo is null
      memberNoBr: json['MemberNoBr'] ??
          '', // Use '' as default value if memberNoBr is null
      mobileNo:
          json['MobileNo'] ?? '', // Use '' as default value if mobileNo is null
      paidAmount: json['PaidAmount'] ??
          '', // Use '' as default value if paidAmount is null
      planName:
          json['PlanName'] ?? '', // Use '' as default value if planName is null
      planNo: json['PlanNo'] ?? '', // Use '' as default value if planNo is null
      planSelectionNo: json['PlanSelectionNo'] ??
          '', // Use '' as default value if planSelectionNo is null
      programName: json['ProgramName'] ??
          '', // Use '' as default value if programName is null
      renewDate: json['RenewDate'] ??
          '', // Use '' as default value if renewDate is null
      saleAmount: json['SaleAmount'] ??
          '', // Use '' as default value if saleAmount is null
      startDt:
          json['StartDt'] ?? '', // Use '' as default value if startDt is null
      isTransfered: json['isTransfered'] ??
          '', // Use '' as default value if isTransfered is null
    );
  }
}
