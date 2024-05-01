import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ai_text_to_photo_new/Screens/utils/apiKey.dart';
import 'package:http/http.dart' as http;

class APIs {
  //get answer from chat gpt
  static Future<String> getAnswer(String question) async {
    try {
      //
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),

          //headers
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $ApiKey'
          },

          //body
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "max_tokens": 2000,
            "temperature": 0,
            "messages": [
              {"role": "user", "content": question},
            ]
          }));

      final data = jsonDecode(res.body);

      log('res: $data');
      return data['choices'][0]['message']['content'];
    } catch (e) {
      log('getAnswerE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  static Future<String> makeGeminiRequest(String promt) async {
    // Replace 'YOUR_API_KEY' with your actual Gemini API key
    String hisapiKey = 'AIzaSyAC_AINH6bzNTXUXxpF4Qdym3HSF-jMYjw';
    String myapiKey = 'AIzaSyB2aKoTh7yXpAG6TuF6aMQkjYE5MCoJZKc';

    String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$hisapiKey';

    // Replace the following JSON with your actual request payload
    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": promt}
          ]
        }
      ]
    };

    try {
      // Make a POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Check if the 'candidates' array is present and not empty
        if (jsonResponse.containsKey('candidates') &&
            jsonResponse['candidates'].isNotEmpty) {
          var content = jsonResponse['candidates'][0]['content'];

          // Check if the 'parts' array is present and not empty
          if (content.containsKey('parts') && content['parts'].isNotEmpty) {
            var generatedContent = content['parts'][0]['text'];
            return (generatedContent);
          } else {
            return ('Invalid response structure - missing parts array.');
          }
        } else {
          return ('Invalid response structure - missing candidates array.');
        }
      } else {
        // Handle error
        print('Response: ${response.body}');
        return ('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      return ('Exception: $e');
    }
  }
}
