class UserModel {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String dob;
  final String br_name;
  final String member_no;
  final String mem_status;
  final String BranchNo;

  UserModel( {
    required this.BranchNo,
    required this.dob,
    required this.br_name,
    required this.member_no,
    required this.mem_status,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
  });
}
