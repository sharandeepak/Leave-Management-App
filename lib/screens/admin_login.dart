import 'package:face_recognition_companion/screens/admin.dart';
import 'package:face_recognition_companion/widgets/custom_button.dart';
import 'package:face_recognition_companion/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

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

class _AdminLoginState extends State<AdminLogin> {
  //-------------DropDown---------
  List<Division> _Division = Division.getDivision();
  List<DropdownMenuItem<Division>> _dropdownMenuItems;
  Division _selectedDivision;
  String _adminPost, _adminDivision, _adminPassword;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_Division);
    _selectedDivision = _dropdownMenuItems[0].value;
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
      _adminDivision = selectedDivision.name;
    });
  }

  NullWarning(String text) {
    Widget no = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Info"),
      content: Text(text),
      actions: [
        no,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void validate() {
    if (_adminPost == null ||
        _adminDivision == "Select Division" ||
        _adminPassword == null) {
      NullWarning("Please Enter All the necessary Information");
    } else {
      if (_adminPassword != "123") {
        NullWarning("Invalid Password");
      } else {
        print("DIVISION" + _adminDivision);
        print("Post" + _adminPost);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminPanel(post: _adminPost,division: _adminDivision)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _passwordFocusNode, _divisionFocusNode;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[300], Colors.red[300]])),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text(
                    "Welcome Admin,\nLogin to your account",
                    textAlign: TextAlign.center,
                    style: constants.boldHeading,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customInput(
                      HintText: 'Post',
                      onChanged: (value) {
                        _adminPost = value.toLowerCase();
                      },
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
                      HintText: 'Password',
                      onChanged: (value) {
                        _adminPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPassword: true,
                      onSubmitted: (value) {
                        validate();
                      },
                    ),
                    CustomButton(
                      text: "Login",
                      onPressed: () {
                        validate();
                      },
                      outlineBtn: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
