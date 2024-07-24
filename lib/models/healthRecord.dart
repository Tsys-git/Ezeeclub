class HealthDetail {
  String? alimentaryTestAilments;
  String? asthma;
  String? bp;
  String? bpPulse;
  String? back;
  String? branchNo;
  String? cardiacHistory;
  String? dibeties;
  String? duetoInjury;
  String? duetoInjuryWhen;
  String? followUp;
  String? gynaecologicalProblems;
  String? healthDetailDate;
  String? healthDetailNo;
  String? hips;
  String? knees;
  String? majorInjuries;
  String? medical;
  String? medicalWhen;
  String? memberNo;
  String? neck;
  String? others;
  String? past;
  String? present;
  String? shoulder;
  String? spondilities;
  String? sugar;
  String? surgeries;
  String? surgical;
  String? surgicalWhen;
  String? thyroidFunction;
  String? trainer;

  HealthDetail({
    this.alimentaryTestAilments,
    this.asthma,
    this.bp,
    this.bpPulse,
    this.back,
    this.branchNo,
    this.cardiacHistory,
    this.dibeties,
    this.duetoInjury,
    this.duetoInjuryWhen,
    this.followUp,
    this.gynaecologicalProblems,
    this.healthDetailDate,
    this.healthDetailNo,
    this.hips,
    this.knees,
    this.majorInjuries,
    this.medical,
    this.medicalWhen,
    this.memberNo,
    this.neck,
    this.others,
    this.past,
    this.present,
    this.shoulder,
    this.spondilities,
    this.sugar,
    this.surgeries,
    this.surgical,
    this.surgicalWhen,
    this.thyroidFunction,
    this.trainer,
  });

  factory HealthDetail.fromJson(Map<String, dynamic> json) => HealthDetail(
        alimentaryTestAilments: json['AlimentaryTestAilments'],
        asthma: json['Asthma'],
        bp: json['BP'],
        bpPulse: json['BPPulse'],
        back: json['Back'],
        branchNo: json['BranchNo'],
        cardiacHistory: json['CardiacHistory'],
        dibeties: json['Dibeties'],
        duetoInjury: json['DuetoInjury'],
        duetoInjuryWhen: json['DuetoInjuryWhen'],
        followUp: json['FollowUp'],
        gynaecologicalProblems: json['GynaecologicalProblems'],
        healthDetailDate: json['HealthDetailDate'],
        healthDetailNo: json['HealthDetailNo'],
        hips: json['Hips'],
        knees: json['Knees'],
        majorInjuries: json['MajorInjuries'],
        medical: json['Medical'],
        medicalWhen: json['MedicalWhen'],
        memberNo: json['MemberNo'],
        neck: json['Neck'],
        others: json['Others'],
        past: json['Past'],
        present: json['Present'],
        shoulder: json['Shoulder'],
        spondilities: json['Spondilities'],
        sugar: json['Sugar'],
        surgeries: json['Surgeries'],
        surgical: json['Surgical'],
        surgicalWhen: json['SurgicalWhen'],
        thyroidFunction: json['ThyroidFunction'],
        trainer: json['Trainer'],
      );

  Map<String, dynamic> toJson() => {
        'AlimentaryTestAilments': alimentaryTestAilments,
        'Asthma': asthma,
        'BP': bp,
        'BPPulse': bpPulse,
        'Back': back,
        'BranchNo': branchNo,
        'CardiacHistory': cardiacHistory,
        'Dibeties': dibeties,
        'DuetoInjury': duetoInjury,
        'DuetoInjuryWhen': duetoInjuryWhen,
        'FollowUp': followUp,
        'GynaecologicalProblems': gynaecologicalProblems,
        'HealthDetailDate': healthDetailDate,
        'HealthDetailNo': healthDetailNo,
        'Hips': hips,
        'Knees': knees,
        'MajorInjuries': majorInjuries,
        'Medical': medical,
        'MedicalWhen': medicalWhen,
        'MemberNo': memberNo,
        'Neck': neck,
        'Others': others,
        'Past': past,
        'Present': present,
        'Shoulder': shoulder,
        'Spondilities': spondilities,
        'Sugar': sugar,
        'Surgeries': surgeries,
        'Surgical': surgical,
        'SurgicalWhen': surgicalWhen,
        'ThyroidFunction': thyroidFunction,
        'Trainer': trainer,
      };
}
