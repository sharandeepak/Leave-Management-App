//This page is to get all the info about the leave
import 'package:face_recognition_companion/screens/Login_Screen.dart';
import 'package:face_recognition_companion/screens/constants.dart';
import 'package:face_recognition_companion/widgets/custom_input.dart';
import 'package:face_recognition_companion/widgets/date_picker.dart';
import 'package:face_recognition_companion/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; //for date format

class LeaveForm extends StatefulWidget {
  final String UIN;
  final String Name;
  final String Post;
  final String Division;
  final String PhoneNo;

  LeaveForm({this.UIN, this.Name, this.Post, this.Division, this.PhoneNo});

  @override
  _LeaveFormState createState() => _LeaveFormState();
}

//----------Drop Down --------------------------
class LeaveType {
  int id;
  String name;

  LeaveType(this.id, this.name);

  static List<LeaveType> getLeaveType() {
    return <LeaveType>[
      LeaveType(1, 'Select Leave Type'),
      LeaveType(2, 'CL'),
      LeaveType(3, 'Rest'),
      LeaveType(4, 'HP'),
      LeaveType(5, 'CR'),
      LeaveType(6, 'LAP'),
      LeaveType(7, 'Sick'),
      LeaveType(8, 'PL'),
      LeaveType(9, 'ML'),
      LeaveType(10, 'SCL'),
      LeaveType(11, 'CCL'),
    ];
  }
}

class _LeaveFormState extends State<LeaveForm> {
  List<LeaveType> _leaveType = LeaveType.getLeaveType();
  List<DropdownMenuItem<LeaveType>> _dropdownMenuItems;
  LeaveType _selectedLeaveType;
  String type_of_leave;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_leaveType);
    _selectedLeaveType = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<LeaveType>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<LeaveType>> items = List();
    for (LeaveType leaveType in companies) {
      items.add(
        DropdownMenuItem(
          value: leaveType,
          child: Text(leaveType.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(LeaveType selectedLeaveType) async {
    setState(() {
      _selectedLeaveType = selectedLeaveType;
      type_of_leave = selectedLeaveType.name;
    });
  }

  String _reason;

  //-----------Date Picker-------------
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  bool _isPressed = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));
  Logger logger = new Logger();
  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _startDate,
        firstDate: new DateTime(DateTime.now().year),
        lastDate: new DateTime(DateTime.now().year + 100));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
        _isPressed = true;
      });
    }
  }

  //---------Get Data from shared preferences-----------------
  String _loginUIN = "";
  String _loginName = "";
  String _loginPost = "";
  String _loginPhone = "";
  String _loginDivision = "";
  Future<void> getDataFromLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _loginUIN = pref.getString("UIN");
    _loginName = pref.getString("Name");
    _loginPost = pref.getString("Post");
    _loginDivision = pref.getString("Division");
    _loginPhone = pref.getString("Phone");
    print("Name:" + _loginName);
    print("Post:" + _loginPost);
    print("Division:" + _loginDivision);
  }

  //--------FireBase------------------
  final fb = FirebaseDatabase.instance;
  uploadData(String path, String start_date, String end_date, String typeLeave,
      String _reason) {
    logger.i("im done");
    final ref = fb.reference();
    ref.child(path).push().set({
      "UIN": widget.UIN,
      "Name": widget.Name,
      "Post": widget.Post,
      "Division": widget.Division,
      "PhoneNo": widget.PhoneNo,
      "Type of leave": typeLeave,
      "From Date": start_date,
      "To Date": end_date,
      "Reason": _reason
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackBar = new SnackBar(
      content: new Text("Sent Successfully!!"),
      padding: EdgeInsets.only(left: 125),
      duration: new Duration(seconds: 2),
      backgroundColor: Colors.green,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = new Logger();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange[300], Colors.red[300]])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Leave Form",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 90.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 90.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: Color(0xFFf2F2F2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: DropdownButton(
                  autofocus: true,
                  value: _selectedLeaveType,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
              ),
              Container(
                child: Center(
                  child: Column(
                    children: [
                      CustomButton(
                        isLoading: false,
                        text: _isPressed
                            ? "Duration       " +
                                _startDate.day.toString() +
                                " - " +
                                _endDate.day.toString()
                            : "Duration",
                        outlineBtn: true,
                        onPressed: () async {
                          _isPressed = true;

                          await displayDateRangePicker(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              customInput(
                HintText: "Reason",
                maxLiness: 3,
                onChanged: (value) {
                  _reason = value;
                },
              ),
              CustomButton(
                text: "Submit",
                onPressed: () {
                  _showSnackBar();
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      // Here you can write your code for open new view
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    });
                  });

                  getDataFromLocal();
                  //logger.i("DIVISION"+widget.Division);
                  uploadData(
                      widget.Division + "/" + widget.Post + "/users/",
                      dateFormat.format(_startDate),
                      dateFormat.format(_endDate),
                      type_of_leave,
                      _reason);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormatDate {}
