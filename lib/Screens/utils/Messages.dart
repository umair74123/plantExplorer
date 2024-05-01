import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastM {
  static void message(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: whiteClr,
      textColor: blackClr,
    );
  }

  static void message2(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: whiteClr,
      textColor: blackClr,
    );
  }
}
