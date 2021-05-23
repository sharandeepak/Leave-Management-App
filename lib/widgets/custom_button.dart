import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineBtn;
  final bool isLoading;

  const CustomButton(
      {this.text, this.onPressed, this.outlineBtn, this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool _outlinedBtn = outlineBtn ?? false;
    bool _isLoading = isLoading ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _outlinedBtn ? Colors.transparent : HexColor('#FDCA40'),
            boxShadow: [
                BoxShadow(
                  color: _outlinedBtn ? Colors.grey.withOpacity(0.0): Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            border: Border.all(
              color: Colors.black,
              width: _outlinedBtn ? 2.5 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(
                  text ?? "Text",
                  style: TextStyle(
                      color: _outlinedBtn ? Colors.black: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
