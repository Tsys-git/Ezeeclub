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

  String get username => _username;
  String get password => _password;

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

  String Name = "";
  String get name => Name;
}
