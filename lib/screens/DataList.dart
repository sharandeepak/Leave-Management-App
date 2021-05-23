import 'package:face_recognition_companion/Model/modelClass.dart';
import 'package:face_recognition_companion/screens/Data_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserDataList extends StatefulWidget {
  @override
  _UserDataListState createState() => _UserDataListState();
}

class _UserDataListState extends State<UserDataList> {
  @override
  Widget build(BuildContext context) {
    final dataa = Provider.of<List<MyModel>>(context);
    
    return ListView.builder(
      itemCount: dataa.length,
      itemBuilder: (context, index) {
        return DataListTile(m : dataa[index]);
      },
    );
  }
}
