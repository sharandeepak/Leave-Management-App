import 'package:face_recognition_companion/Model/modelClass.dart';
import 'package:flutter/material.dart';

class DataListTile extends StatelessWidget {
  final MyModel m;

  const DataListTile({this.m});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('UIN'),
                Text(m.uin)
              ],
            )
          ],
        ),
      ),
    );
  }
}
