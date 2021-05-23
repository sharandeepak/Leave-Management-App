//Login Page in which the Users will enter the UIN and Password
import 'package:face_recognition_companion/screens/admin.dart';
import 'package:face_recognition_companion/screens/leave_form.dart';
import 'package:face_recognition_companion/screens/showQR.dart';
import 'package:face_recognition_companion/widgets/custom_button.dart';
import 'package:face_recognition_companion/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:face_recognition_companion/screens/constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String loginUIN;
  final String loginName;

  const LoginScreen({this.loginUIN, this.loginName});
  @override 
  _LoginScreenState createState() => _LoginScreenState();
}

//---------DropDown-------------------
class Division {
  int id;
  String name;

  Division(this.id, this.name);

  static List<Division> getDivision() {
    return <Division>[
      Division(1, 'Select Division'),
      Division(2, 'HQr'),
      Division(3, 'MAS'),
      Division(4, 'TPJ'),
      Division(5, 'MDU'),
      Division(6, 'TVC'),
      Division(7, 'PGT'),
      Division(8, 'SA'),
      Division(9, 'TCKG'),
    ];
  }
}

class _LoginScreenState extends State<LoginScreen> {
  //-------------DropDown---------
  List<Division> _Division = Division.getDivision();
  List<DropdownMenuItem<Division>> _dropdownMenuItems;
  Division _selectedDivision;
  String _loginDivision;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_Division);
    _selectedDivision = _dropdownMenuItems[0].value;
    LoginCheck();
  }

  List<DropdownMenuItem<Division>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Division>> items = List();
    for (Division division in companies) {
      items.add(
        DropdownMenuItem(
          value: division,
          child: Text(division.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Division selectedDivision) {
    setState(() {
      _selectedDivision = selectedDivision;
      _loginDivision = selectedDivision.name;
    });
  }

  //--------------------------------------------------------------
  Logger logger = Logger();
  FocusNode _nameFocusNode, _phoneFocusNode, _postFocusNode, _divisionFocusNode;
  bool _isLoggedIn = false;
  String _loginUIN = "";
  String _loginName = "";
  String _loginPost = "";
  String _loginPhone = "";

  void _submitForm() async {
    _setbool();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LeaveForm(
              UIN: _loginUIN,
              Name: _loginName,
              Post: _loginPost,
              Division: _loginDivision,
              PhoneNo: _loginPhone)),
    );
  }

  Future<void> _getboolfun() async {
    final prefs = await SharedPreferences.getInstance();
    final _getbool = prefs.getBool("loggedin");

    if (_getbool != null) {
      setState(() {
        _isLoggedIn = _getbool;
        _loginUIN = prefs.getString("UIN");
        _loginName = prefs.getString("Name");
        _loginPost = prefs.getString("Post");
        _loginDivision = prefs.getString("Division");
        _loginPhone = prefs.getString("Phone");
      });
    }
  }

  Future<void> _setbool() async {
    setState(() async {
      print("BEFORE SETTING");
      print("POST" + _loginPost);
      print("Division" + _loginDivision);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("loggedIn", true);
      await prefs.setString("UIN", _loginUIN);
      await prefs.setString("Name", _loginName);
      await prefs.setString("Post", _loginPost);
      await prefs.setString("Division", _loginDivision);
      await prefs.setString("Phone", _loginPhone);
    });
  }

  Future<void> LoginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //if First statement is Null Or NO Value is returning then it will give us Second Value
    bool checkLoggedIn = (pref.getBool('loggedIn') ?? false);
    if (checkLoggedIn) {
      setState(() {
        _isLoggedIn = true;
        _loginUIN = pref.getString("UIN");
        _loginName = pref.getString("Name");
        _loginPost = pref.getString("Post");
        _loginDivision = pref.getString("Division");
        _loginPhone = pref.getString("Phone");
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[300], Colors.red[300]])),
            child: _isLoggedIn
                ? 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: "Display QR",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowQr(
                                        dataa: _loginUIN + "." + _loginName)));
                          },
                        ),
                        CustomButton(
                          text: "Leave Form",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LeaveForm(
                                        UIN: _loginUIN,
                                        Name: _loginName,
                                        Post: _loginPost,
                                        Division: _loginDivision,
                                        PhoneNo: _loginPhone)));
                          },
                        )
                      ],
                    )
                  
                : Center(
                    child: Container(
                      // decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //         colors: [Colors.orange[300], Colors.red[300]])),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 24.0,
                              ),
                              child: Text(
                                "Welcome User,\nLogin to your account",
                                textAlign: TextAlign.center,
                                style: constants.boldHeading,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customInput(
                                    HintText: 'UIN',
                                    onChanged: (value) {
                                      _loginUIN = value;
                                    },
                                    onSubmitted: (value) {
                                      _nameFocusNode.requestFocus();
                                    },
                                    textInputAction: TextInputAction.next),
                                customInput(
                                  HintText: 'Name',
                                  onChanged: (value) {
                                    _loginName = value;
                                  },
                                  focusNode: _nameFocusNode,
                                  isPassword: false,
                                  onSubmitted: (value) {
                                    _postFocusNode.requestFocus();
                                  },
                                ),
                                customInput(
                                  HintText: 'Post',
                                  onChanged: (value) {
                                    _loginPost = value.toLowerCase();
                                  },
                                  focusNode: _postFocusNode,
                                  isPassword: false,
                                  onSubmitted: (value) {
                                    _divisionFocusNode.requestFocus();
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 100.0,
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
                                    value: _selectedDivision,
                                    items: _dropdownMenuItems,
                                    onChanged: onChangeDropdownItem,
                                    focusNode: _divisionFocusNode,
                                  ),
                                ),
                                customInput(
                                  HintText: 'Phone No',
                                  onChanged: (value) {
                                    _loginPhone = value;
                                  },
                                  focusNode: _phoneFocusNode,
                                  isPassword: false,
                                  onSubmitted: (value) {
                                    _submitForm();
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: CustomButton(
                                    text: "Login",
                                    onPressed: () {
                                      _setbool();
                                      logger.d(_loginDivision);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginScreen(
                                                  loginUIN: _loginUIN,
                                                  loginName: _loginName)));
                                    },
                                    outlineBtn: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
      ),
    );
  }
}
