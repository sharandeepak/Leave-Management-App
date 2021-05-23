import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQr extends StatefulWidget {
  final dataa;

  const ShowQr({this.dataa});
  @override
  _ShowQrState createState() => _ShowQrState();
}

class _ShowQrState extends State<ShowQr> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: QrImage(
              data: widget.dataa,
              version: QrVersions.auto,
              size: 250.0,
              
            ),
          ),
        ],
      ),
    );
  }
}
