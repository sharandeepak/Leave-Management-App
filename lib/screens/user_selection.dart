//This page is to select whether the user is a admin or not and store it in a shared preferences
import 'package:face_recognition_companion/screens/Login_Screen.dart';
import 'package:face_recognition_companion/screens/admin.dart';
import 'package:face_recognition_companion/screens/admin_login.dart';
import 'package:face_recognition_companion/screens/constants.dart';
import 'package:face_recognition_companion/screens/password.dart';
import 'package:face_recognition_companion/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[300], Colors.red[300]])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80,horizontal: 0),
                  child: Image.asset("assets/images/appLogo.png",width: 150,height:150,),
                ),
                
                CustomButton(
                  text: "User",
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                CustomButton(
                  text: "Admin",
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLogin()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
