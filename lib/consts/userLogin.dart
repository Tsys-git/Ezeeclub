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
    await prefs.remove('isLoggedIn');
  }

  String _username = "";
  String _password = "";
  String _mobile_no = "";
  String _name = "";
  String _memberno = "";
  String get username => _username;
  String get password => _password;
  String get mobile_no => _mobile_no;
  String get name => _name;
  String get memberno => _memberno;

  Future<void> setmemberno(String memberno) async {
    _memberno = memberno;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('memberno', memberno);
  }

  Future<String> getmemberno() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memberno = prefs.getString('memberno');
    if (memberno != null && memberno.isNotEmpty) {
      _memberno = memberno;
    }
    return memberno!;
  }

  Future<void> setname(String name) async {
    _name = name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  Future<String> getname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    if (name != null && name.isNotEmpty) {
      _name = name;
    }
    return name!;
  }

  Future<void> setmobile_no(String mobile_no) async {
    _mobile_no = mobile_no;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile_no', mobile_no);
  }

  Future<String> getmobile_no() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile_no = prefs.getString('mobile_no');
    if (mobile_no != null && mobile_no.isNotEmpty) {
      _mobile_no = mobile_no;
    }
    return mobile_no!;
  }

  Future<void> setUsername(String username) async {
    _username = username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null && username.isNotEmpty) {
      _username = username;
    }
  }

  Future<void> setPassword(String password) async {
    _password = password;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  Future<void> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString('password');
    if (password != null && password.isNotEmpty) {
      _password = password;
    }
  }

  // Method to check and restore login state from SharedPreferences
  Future<void> restoreLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }
}
