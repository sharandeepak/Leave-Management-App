import 'package:face_recognition_companion/Model/ModelSheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FormController {
  final void Function(String) callback;
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwbnyQBidSTk6wrCwkp1D9i9PsGdLksnCGyjgD0YLdcKjgpTqPrfr56Jw/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);
  void submitForm(ModelSheet modelSheet) async {
    try {
      await http.get(URL + modelSheet.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e + "Exception");
    }
  }
}
