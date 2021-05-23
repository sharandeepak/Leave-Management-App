import 'package:face_recognition_companion/screens/constants.dart';
import 'package:face_recognition_companion/widgets/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:logger/logger.dart';

class DatePicking extends StatefulWidget {
  @override
  _DatePickingState createState() => _DatePickingState();
}

class _DatePickingState extends State<DatePicking> {
  final fb = FirebaseDatabase.instance;
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

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("data");
    return Container(
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
    );
  }
}
