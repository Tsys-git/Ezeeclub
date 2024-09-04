import 'dart:convert';
import 'package:ezeeclub/consts/URL_Setting.dart';
import 'package:ezeeclub/consts/userLogin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SlotBooking extends StatefulWidget {
  const SlotBooking({super.key});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String? _selectedBranch;
  String? _selectedSlot;
  String mob_no = ""; // Initialize with an empty string
  String name = " ";
  List<String> timeSlots = [];
  List<String> branches = [];

  @override
  void initState() {
    super.initState();
    timeSlots = generateTimeSlots();
    fetchBranches();
    loadMobileNumberandname();
  }

  Future<void> loadMobileNumberandname() async {
    UserLogin userLogin = UserLogin();
    String? mobileNumber = await userLogin.getMobileNo();
    String? Name = await userLogin.getName();
    setState(() {
      mob_no = mobileNumber ?? ""; // Update the state
      name = Name ?? "";
      print('Updated mob_no: $mob_no'); // Debug log
      _mobileNoController.text = mob_no; // Update the controller's text
      _nameController.text = name;
    });
  }

  Future<void> fetchBranches() async {
    List<String> fetchedBranches = await getBranches();
    setState(() {
      branches = fetchedBranches;
    });
  }

  Future<List<String>> getBranches() async {
    UrlSetting urlSetting = UrlSetting();

    try {
      await urlSetting.initialize();
      final Uri? apiUrl = urlSetting.getBranchDetails;
      final response = await http.post(apiUrl!);

      if (response.statusCode == 200) {
        List<String> branches = [];

        // Parse the JSON data
        final data = jsonDecode(response.body);
        print(data);
        // Assuming the API returns a list of branches as strings
        for (var branch in data) {
          branches.add(branch['Branchname']); // Adjust the key if needed
        }
        return branches;
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  List<String> generateTimeSlots() {
    List<String> slots = [];
    DateTime startTime = DateTime(2024, 8, 9, 6, 0); // Start time: 6:00 AM
    DateTime endTime = DateTime(2024, 8, 9, 22, 0); // End time: 9:00 PM
    DateFormat formatter = DateFormat.jm(); // 12-hour format

    while (startTime.isBefore(endTime)) {
      DateTime nextSlot = startTime.add(Duration(hours: 1));
      slots.add(
          "${formatter.format(startTime)} - ${formatter.format(nextSlot)}");
      startTime = nextSlot;
    }

    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Slot Booking ",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a date';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: _mobileNoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Mobile No',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.call),
                            ),
                            enabled: true, // Make it uneditable
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a mobile number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              enabled: false,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        labelText: 'Branch',
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,)),
                      ),
                      value: _selectedBranch,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBranch = newValue;
                        });
                      },
                      items: branches.isEmpty
                          ? [
                              DropdownMenuItem(
                                value: 'Select',
                                child: Text('Select'),
                              )
                            ]
                          : branches
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      validator: (value) {
                        if (value == null || value == 'Select') {
                          return 'Please select a branch';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.alarm),
                              labelText: 'Slot',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedSlot,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedSlot = newValue;
                              });
                            },
                            items: timeSlots
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value == 'Select') {
                                return 'Please select a slot';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Process data
                              print("save data button");
                              setState(() {
                                _selectedBranch = null;
                                _selectedSlot = null;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Save'),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                            setState(() {
                              _selectedBranch = null;
                              _selectedSlot = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
