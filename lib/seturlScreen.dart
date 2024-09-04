import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/Auth/login.dart';

class SetUrlScreen extends StatefulWidget {
  const SetUrlScreen({super.key});

  @override
  _SetUrlScreenState createState() => _SetUrlScreenState();
}

class _SetUrlScreenState extends State<SetUrlScreen> {
  final List<String> urlOptions = [
    'oneabovefit.ezeeclub.net',
    'janorkarsgym.ezeeclub.net',
  ];
  String selectedUrl = '';

  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }

  // Function to load the previously saved URL from SharedPreferences
  Future<void> _loadSavedUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedUrl = prefs.getString('apiUrl') ?? '';
    });
  }

  // Function to save the selected URL to SharedPreferences
  Future<void> _saveUrl(String newUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_url', newUrl);
    setState(() {
      selectedUrl = newUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set URL',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedUrl.isEmpty ? null : selectedUrl,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).primaryColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .primaryColor, // Using primary color for focused border
                          width: 2,
                        ),
                      ),
                      prefixIcon: Icon(Icons.open_in_browser),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      hintText: 'Select API URL',
                    ),
                    items: urlOptions.map((url) {
                      return DropdownMenuItem<String>(
                        value: url,
                        child: Text(url),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUrl = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (selectedUrl.isNotEmpty) {
                        _saveUrl(selectedUrl);
                        Get.off(() => LoginScreen()); // Navigate to loginScreen
                      } else {
                        // Show error or prompt to select URL
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Please select a valid URL.',
                                style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text('Save URL'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
