import 'package:face_recognition_companion/screens/Login_Screen.dart';
import 'package:face_recognition_companion/screens/leave_form.dart';
import 'package:face_recognition_companion/screens/user_selection.dart';
import 'package:face_recognition_companion/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Companion App',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        accentColor: Color(0xFFFF1E00)
      ),
      
      home: UserSelection(),
    );
  }
}

