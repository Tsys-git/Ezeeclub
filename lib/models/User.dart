class UserModel {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String dob;
  final String member_no;
  final String mem_status;
  final String BranchNo;
  final String location;

  UserModel(
      {required this.BranchNo,
      required this.dob,
      required this.member_no,
      required this.mem_status,
      required this.fullName,
      required this.phoneNumber,
      required this.email,
      required this.location});
}
