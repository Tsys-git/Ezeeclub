class Dietplan {
  String? dietFood;
  String? dietFromDate;
  String? dietTime;
  String? dietToDate;
  String? dietician;
  String? dsNo;

  Dietplan({
    this.dietFood,
    this.dietFromDate,
    this.dietTime,
    this.dietToDate,
    this.dietician,
    this.dsNo,
  });

  // Factory method to create Dietplan object from JSON
  factory Dietplan.fromJson(Map<String, dynamic> json) {
    return Dietplan(
      dietFood: json['DietFood'],
      dietFromDate: json['DietFromDate'],
      dietTime: json['DietTime'],
      dietToDate: json['DietToDate'],
      dietician: json['Dietician'],
      dsNo: json['DsNo'],
    );
  }

  // Method to convert Dietplan object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'DietFood': dietFood,
      'DietFromDate': dietFromDate,
      'DietTime': dietTime,
      'DietToDate': dietToDate,
      'Dietician': dietician,
      'DsNo': dsNo,
    };
    return data;
  }
}
