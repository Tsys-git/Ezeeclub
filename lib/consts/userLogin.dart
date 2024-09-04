import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  static final UserLogin _instance = UserLogin._internal();

  factory UserLogin() {
    return _instance;
  }

  UserLogin._internal();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    _isLoggedIn = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear all user attributes from SharedPreferences
    await prefs.remove('isLoggedIn');
    await prefs.remove('dob');
    await prefs.remove('mem_status');
    await prefs.remove('location');
    await prefs.remove('email');
    await prefs.remove('branchNo');
    await prefs.remove('memberNo');
    await prefs.remove('name');
    await prefs.remove('mobileNo');
    await prefs.remove('username');
    await prefs.remove('password');
  }

  // User attributes
  String _username = "";
  String _password = "";
  String _mobileNo = "";
  String _name = "";
  String _memberNo = "";
  String _branchNo = "";
  String _email = "";
  String _dob = "";
  String _mem_status = "";
  String _location = "";

  // Getter methods
  String get username => _username;
  String get password => _password;
  String get mobileNo => _mobileNo;
  String get name => _name;
  String get memberNo => _memberNo;
  String get branchNo => _branchNo;
  String get email => _email;
  String get dob => _dob;
  String get mem_status => _mem_status;
  String get location => _location;

  // Setter and Getter methods for attributes
  Future<void> _setAttribute(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> _getAttribute(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> setDOB(String dob) async {
    _dob = dob;
    await _setAttribute('dob', dob);
  }

  Future<String?> getDOB() async {
    _dob = await _getAttribute('dob') ?? '';
    return _dob;
  }

  Future<void> setMembershipStatus(String memStatus) async {
    _mem_status = memStatus;
    await _setAttribute('mem_status', memStatus);
  }

  Future<String?> getMembershipStatus() async {
    _mem_status = await _getAttribute('mem_status') ?? '';
    return _mem_status;
  }

  Future<void> setLocation(String location) async {
    _location = location;
    await _setAttribute('location', location);
  }

  Future<String?> getLocation() async {
    _location = await _getAttribute('location') ?? '';
    return _location;
  }

  Future<void> setEmail(String email) async {
    _email = email;
    await _setAttribute('email', email);
  }

  Future<String?> getEmail() async {
    _email = await _getAttribute('email') ?? '';
    return _email;
  }

  Future<void> setBranchNo(String branchNo) async {
    _branchNo = branchNo;
    await _setAttribute('branchNo', branchNo);
  }

  Future<String?> getBranchNo() async {
    _branchNo = await _getAttribute('branchNo') ?? '';
    return _branchNo;
  }

  Future<void> setMemberNo(String memberNo) async {
    _memberNo = memberNo;
    await _setAttribute('memberNo', memberNo);
  }

  Future<String?> getMemberNo() async {
    _memberNo = await _getAttribute('memberNo') ?? '';
    return _memberNo;
  }

  Future<void> setName(String name) async {
    _name = name;
    await _setAttribute('name', name);
  }

  Future<String?> getName() async {
    _name = await _getAttribute('name') ?? '';
    return _name;
  }

  Future<void> setMobileNo(String mobileNo) async {
    _mobileNo = mobileNo;
    await _setAttribute('mobileNo', mobileNo);
  }

  Future<String?> getMobileNo() async {
    _mobileNo = await _getAttribute('mobileNo') ?? '';
    return _mobileNo;
  }

  Future<void> setUsername(String username) async {
    _username = username;
    await _setAttribute('username', username);
  }

  Future<void> getUsername() async {
    _username = await _getAttribute('username') ?? '';
  }

  Future<void> setPassword(String password) async {
    _password = password;
    await _setAttribute('password', password);
  }

  Future<void> getPassword() async {
    _password = await _getAttribute('password') ?? '';
  }

  // Restore login state
  Future<void> restoreLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }
}
