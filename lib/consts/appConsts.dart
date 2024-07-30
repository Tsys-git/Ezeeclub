import 'package:shared_preferences/shared_preferences.dart';

class AppConsts {
  // Singleton instance
  static final AppConsts _instance = AppConsts._internal();

  factory AppConsts() {
    return _instance;
  }

  AppConsts._internal();

  // Observable Uri
  Uri _url = Uri.parse("");

  // Getter for URL
  Uri get url => _url;

  // Method to update the URL and save it to SharedPreferences
  Future<void> updateUrl(String newUrl) async {
    _url = Uri.parse(newUrl);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_url', newUrl);
  }

  // Method to load URL from SharedPreferences
  Future<void> loadUrlFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUrl = prefs.getString('app_url');
    if (storedUrl != null && storedUrl.isNotEmpty) {
      _url = Uri.parse(storedUrl);
    }
  }


   Future<Uri> getStoredUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUrl = prefs.getString('app_url');
    return Uri.parse(storedUrl ?? "");
  }
  
}

