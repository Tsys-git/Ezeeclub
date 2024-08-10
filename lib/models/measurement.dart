class Measurement {
  final String? activity;
  final String? age;
  final String? arms;
  final String? bmi;
  final String? bmr;
  final String? biochemPara;
  final String? bodyFat;
  final String? bodyWater;
  final String? boneMass;
  final String? branchName;
  final String? calf;
  final String? chestNormal;
  final String? chstExpanded;
  final String? dietRecall;
  final String? empName;
  final String? empNo;
  final String? forearm;
  final String? heightInches;
  final String? hip;
  final String? hoursToSleep;
  final String? idealBodyFat;
  final String? lowerAbdomen;
  final String? measurementDate;
  final String? measurementNo;
  final String? memberName;
  final String? memberNo;
  final String? memberNoBr;
  final String? muscleMass;
  final String? neck;
  final String? physiqueRating;
  final String? remark;
  final String? sekelArms;
  final String? sekelLegs;
  final String? sekelTrunk;
  final String? sekelWholeBody;
  final String? subcuArms;
  final String? subcuLegs;
  final String? subcuTrunks;
  final String? subcuWholeBody;
  final String? thigh;
  final String? upperAbdomen;
  final String? visceralFat;
  final String? whr;
  final String? waist;
  final String? waistCircum;
  final String? waterIntake;
  final String? weight;
  final String? shoulder;

  Measurement({
    this.activity,
    this.age,
    this.arms,
    this.bmi,
    this.bmr,
    this.biochemPara,
    this.bodyFat,
    this.bodyWater,
    this.boneMass,
    this.branchName,
    this.calf,
    this.chestNormal,
    this.chstExpanded,
    this.dietRecall,
    this.empName,
    this.empNo,
    this.forearm,
    this.heightInches,
    this.hip,
    this.hoursToSleep,
    this.idealBodyFat,
    this.lowerAbdomen,
    this.measurementDate,
    this.measurementNo,
    this.memberName,
    this.memberNo,
    this.memberNoBr,
    this.muscleMass,
    this.neck,
    this.physiqueRating,
    this.remark,
    this.sekelArms,
    this.sekelLegs,
    this.sekelTrunk,
    this.sekelWholeBody,
    this.subcuArms,
    this.subcuLegs,
    this.subcuTrunks,
    this.subcuWholeBody,
    this.thigh,
    this.upperAbdomen,
    this.visceralFat,
    this.whr,
    this.waist,
    this.waistCircum,
    this.waterIntake,
    this.weight,
    this.shoulder,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      activity: json['Activity'],
      age: json['Age'],
      arms: json['Arms'],
      bmi: json['BMI'],
      bmr: json['BMR'],
      biochemPara: json['BiochemPara'],
      bodyFat: json['BodyFat'],
      bodyWater: json['BodyWater'],
      boneMass: json['BoneMass'],
      branchName: json['BranchName'],
      calf: json['Calf'],
      chestNormal: json['ChestNormal'],
      chstExpanded: json['ChstExpanded'],
      dietRecall: json['DietRecall'],
      empName: json['EmpName'],
      empNo: json['EmpNo'],
      forearm: json['Forearm'],
      heightInches: json['HeightInches'],
      hip: json['Hip'],
      hoursToSleep: json['HoursTosleep'],
      idealBodyFat: json['IdealBodyFat'],
      lowerAbdomen: json['LowerAbdomen'],
      measurementDate: json['MeasurementDate'],
      measurementNo: json['MeasurementNo'],
      memberName: json['MemberName'],
      memberNo: json['MemberNo'],
      memberNoBr: json['MemberNoBr'],
      muscleMass: json['MuscleMass'],
      neck: json['Neck'],
      physiqueRating: json['PhysiqueRating'],
      remark: json['Remark'],
      sekelArms: json['SekelArms'],
      sekelLegs: json['SekelLegs'],
      sekelTrunk: json['SekelTrunk'],
      sekelWholeBody: json['SekelWholeBody'],
      subcuArms: json['SubcuArms'],
      subcuLegs: json['SubcuLegs'],
      subcuTrunks: json['SubcuTrunks'],
      subcuWholeBody: json['SubcuWholeBody'],
      thigh: json['Thigh'],
      upperAbdomen: json['UpperAbdomen'],
      visceralFat: json['VisceralFat'],
      whr: json['WHR'],
      waist: json['Waist'],
      waistCircum: json['Waistcircum'],
      waterIntake: json['WaterIntake'],
      weight: json['Weight'],
      shoulder: json['shoulder'],
    );
  }
}
