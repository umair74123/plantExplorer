import 'dart:convert';
import 'dart:io';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageDescriber extends StatefulWidget {
  const ImageDescriber({super.key});

  @override
  State<ImageDescriber> createState() => _ImageDescriberState();
}

class _ImageDescriberState extends State<ImageDescriber> {
  XFile? pickedImage;
  String mytext = '';
  bool scanning = false;

  TextEditingController prompt = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  final apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyByYA8QjPerMw0o0LZUiHFphTcMqPTuYXY';

  final header = {
    'Content-Type': 'application/json',
  };

  getImage(ImageSource ourSource) async {
    XFile? result = await _imagePicker.pickImage(source: ourSource);

    if (result != null) {
      setState(() {
        pickedImage = result;
      });
    }
  }

  getdata(image, promptValue) async {
    setState(() {
      scanning = true;
      mytext = '';
    });

    try {
      List<int> imageBytes = File(image.path).readAsBytesSync();
      String base64File = base64.encode(imageBytes);

      final data = {
        "contents": [
          {
            "parts": [
              {"text": promptValue},
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": base64File,
                }
              }
            ]
          }
        ],
      };

      await http
          .post(Uri.parse(apiUrl), headers: header, body: jsonEncode(data))
          .then((response) {
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          mytext = result['candidates'][0]['content']['parts'][0]['text'];
        } else {
          mytext = 'Response status : ${response.statusCode}';
        }
      }).catchError((error) {
        print('Error occored ${error}');
      });
    } catch (e) {
      print('Error occured ${e}');
    }

    scanning = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainclr,
      appBar: AppBar(
        title:
            Text('Image Describer', style: GoogleFonts.inter(color: whiteClr)),
        backgroundColor: mainclr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            pickedImage == null
                ? InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery);
                    },
                    child: Container(
                        height: 340,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: blackClr,
                              width: 2.0,
                            ),
                            color: whiteClr),
                        child: Center(
                          child: Text(
                            'Choose Image ',
                            style: TextStyle(fontSize: 22, color: blackClr),
                          ),
                        )),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        mytext = '';
                        prompt.text = '';
                      });
                      getImage(ImageSource.gallery);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: whiteClr,
                        ),
                        height: 340,
                        child: Image.file(
                          File(pickedImage!.path),
                          // height: 400,
                          fit: BoxFit.cover,
                        )),
                  ),
            SizedBox(height: 20),
            TextField(
              controller: prompt,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: whiteClr,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: whiteClr,
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.pending_sharp,
                  color: whiteClr,
                ),
                hintStyle: TextStyle(color: Colors.white38),
                hintText: 'eg. Describe the Image',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                getdata(pickedImage, prompt.text);
              },
              icon: Icon(
                Icons.generating_tokens_rounded,
                color: Colors.black,
              ),
              label: Padding(
                padding: const EdgeInsets.all(17),
                child: Text(
                  'Generate Answer',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: whiteClr,
              ),
            ),
            SizedBox(height: 30),
            scanning
                ? Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    )),
                  )
                : mytext.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(color: whiteClr),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(mytext,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20, color: whiteClr)),
                      )
                    : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: mytext.isNotEmpty
          ? InkWell(
              onTap: () {
                setState(() {
                  mytext = '';
                  prompt.text = '';
                });
                getImage(ImageSource.gallery);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                color: whiteClr,
                child: Center(
                  child: Text(
                    "Choose another Image",
                    style: TextStyle(
                        color: blackClr,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
