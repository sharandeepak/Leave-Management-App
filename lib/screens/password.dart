import 'package:face_recognition_companion/screens/admin.dart';
import 'package:face_recognition_companion/screens/constants.dart';
import 'package:face_recognition_companion/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class Password extends StatelessWidget {
  String _password;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enter Password", style: constants.regularDarkText),
                customInput(
                  HintText: "Password",
                  isPassword: true,
                  onChanged: (value) {
                    _password = value;
                    if (_password == "123") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdminPanel()));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
