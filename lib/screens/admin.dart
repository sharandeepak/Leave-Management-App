import 'package:face_recognition_companion/Model/ModelSheet.dart';
import 'package:face_recognition_companion/Model/controller.dart';
import 'package:face_recognition_companion/Model/modelClass.dart';
import 'package:face_recognition_companion/screens/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AdminPanel extends StatefulWidget {
  final String post;
  final String division;

  const AdminPanel({this.post, this.division});

  @override
  _AdminPanel createState() => _AdminPanel();
}

class _AdminPanel extends State<AdminPanel> {
  static String divisionn, postt;

  List<MyModel> list = List();
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  void launchWhatsapp({@required no, @required message}) async {
    String url = "whatsapp://send?phone=$no&text=$message";
    await canLaunch(url) ? launch(url) : print('Cant Launch Whatsapp');
  }

  @override
  void initState() {
    divisionn = widget.division;
    postt = widget.post;
    final fb1 = FirebaseDatabase.instance
        .reference()
        .child(divisionn + "/" + postt + "/users/");
    // final fb2 = FirebaseDatabase.instance
    //     .reference()
    //     .child(divisionn + "/" + postt + "/users/Rest");
    // final fb3 = FirebaseDatabase.instance
    //     .reference()
    //     .child(divisionn + "/" + postt + "/users/HP");
    // final fb4 = FirebaseDatabase.instance
    //     .reference()
    //     .child(divisionn + "/" + postt + "/users/CR");
    // final fb5 = FirebaseDatabase.instance
    //     .reference()
    //     .child(divisionn + "/" + postt + "/users/LAP");
    // final fb6 = FirebaseDatabase.instance
    //     .reference()
    //     .child(divisionn + "/" + postt + "/users/Sick");
    super.initState();
    fb1.once().then((DataSnapshot snap) {
      var data = snap.value;
      list.clear();
      data.forEach((key, value) {
        MyModel model = new MyModel(
            name: value['Name'],
            post: value['Post'],
            division: value['Division'],
            uin: value['UIN'],
            phoneNo: value['PhoneNo'],
            type_of_leave: value['Type of leave'],
            from_date: value['From Date'],
            to_date: value['To Date'],
            reason: value['Reason'],
            key: key);
        list.add(model);
      });
      setState(() {});
    });
  }

  DeleteData(BuildContext context, String key) {
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        setState(() {
          //fb1.child(key).remove();
          Navigator.of(context).pop();
        });
      },
    );
    Widget no = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete Data"),
      content: Text("Do you want to delete?"),
      actions: [
        okButton,
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

  List<String> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    DateFormat dateFormat = DateFormat("dd/MM");
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime x = DateTime(
          startDate.year,
          startDate.month,
          // In Dart you can set more than. 30 days, DateTime will do the trick
          startDate.day + i);
      days.add(dateFormat.format(x));
    }
    return days;
  }

  _AcceptData(BuildContext context, String key, String uin, String fromDate,
      String toDate, String typeLeave) {
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        String recipients = "+919677078901";
        launchWhatsapp(
          no: recipients,
            message: "Your Request of " +
                typeLeave +
                " From : " +
                fromDate +
                "" +
                " TO : " +
                toDate +
                " Has been granted.",
            );
        setState(() {
          var _startDate = DateFormat("dd/MM/yyyy").parse(fromDate);
          var _toDate = DateFormat("dd/MM/yyyy").parse(toDate);
          List<String> days = getDaysInBeteween(_startDate, _toDate);
          print(days);
          for (String date in days) {
            print("Date" + date);
            ModelSheet modelSheet = ModelSheet(uin, date, typeLeave);
            FormController formController = FormController((String response) {
              print(response);
              Logger logger = Logger();
              if (response == FormController.STATUS_SUCCESS) {
                logger.d("SUBMITTED");
              } else {
                logger.d("Error");
              }
            });
            formController.submitForm(modelSheet);
          }

          Navigator.of(context).pop();
        });
      },
    );
    Widget no = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Accept Request"),
      content: Text("Do you want to Accept?"),
      actions: [
        okButton,
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

  @override
  Widget build(BuildContext context) {
    Widget UI(
        String name,
        String post,
        String division,
        String uin,
        String phoneNo,
        String type_of_leave,
        String from_date,
        String to_date,
        String reason,
        int index,
        String key) {
      return new GestureDetector(
        onLongPress: () {},
        onTap: () {
          print(list[index].name);
        },
        child: Card(
          elevation: 2,
          color: Colors.lightGreen[50],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Text("Name : ", style: constants.regularHeading),
                      Text(name,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[600])),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        "Post/division : ",
                        style: constants.regularHeading,
                      ),
                      Text(
                        post + "/" + division,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("UIN : ", style: constants.regularHeading),
                      Text(
                        uin,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("Phone : ", style: constants.regularHeading),
                      Text(
                        phoneNo,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("Type of Leave : ", style: constants.regularHeading),
                      Text(
                        type_of_leave,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("From Date : ", style: constants.regularHeading),
                      Text(
                        from_date,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("To date : ", style: constants.regularHeading),
                      Text(
                        to_date,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("Reason : ", style: constants.regularHeading),
                      Text(reason,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[600])),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        color: Colors.red[400],
                        onPressed: () {
                          print("Reject ${index}");
                          DeleteData(context, key);
                        },
                        child: Text("Reject"),
                      ),
                      MaterialButton(
                        color: Colors.green[400],
                        onPressed: () {
                          print("Accept ${index}");
                          _AcceptData(context, key, uin, from_date, to_date,
                              type_of_leave);
                        },
                        child: Text("Accept"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Casual Leave"),
        backgroundColor: Colors.blue,
      ),
      body: new Container(
        child: list.length == 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Loading...",
                  style: constants.boldHeading,
                ),
              )
            : new ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return UI(
                      list[index].name,
                      list[index].post,
                      list[index].division,
                      list[index].uin,
                      list[index].phoneNo,
                      list[index].type_of_leave,
                      list[index].from_date,
                      list[index].to_date,
                      list[index].reason,
                      index,
                      list[index].key);
                }),
      ),
    );
  }
}
