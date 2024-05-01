import 'dart:convert';

import 'package:ai_text_to_photo_new/Screens/utils/apiKey.dart';
import 'package:http/http.dart' as http;

class API {
  static final url = Uri.parse("https://api.openai.com/v1/images/generations");
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $ApiKey"
  };

  static generateImage(String text, String s) async {
    try {
      var res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $ApiKey"
        },
        body: jsonEncode({"prompt": text, "n": 1, "size": s}),
      );
      print(res.body);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());

        return data['data'][0]['url'].toString();
      } else {
        print("error occured");
      }
    } catch (e) {
      print(e);
      print("catch error");
    }
  }
}
