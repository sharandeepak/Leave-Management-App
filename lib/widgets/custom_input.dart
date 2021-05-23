import 'package:face_recognition_companion/screens/constants.dart';
import 'package:flutter/material.dart';

class customInput extends StatelessWidget {
  final String HintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPassword;
  final int maxLiness;

  const customInput(
      {this.HintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPassword,
      this.maxLiness});

  @override
  Widget build(BuildContext context) {
    bool _isPassword = isPassword ?? false;
    int _maxlines = maxLiness ?? 1;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFf2F2F2), borderRadius: BorderRadius.circular(12.0)),
      child: TextField(
        focusNode: focusNode,
        obscureText: _isPassword,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        maxLines: _maxlines,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: HintText ?? "Hint text",
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 18.0,
            )),
        style: constants.regularDarkText,
      ),
    );
  }
}
