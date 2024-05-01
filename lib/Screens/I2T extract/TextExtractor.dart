import 'dart:developer';
import 'dart:io';

import 'package:ai_text_to_photo_new/Screens/AdsController/AdsCOntroller.dart';
import 'package:ai_text_to_photo_new/Screens/I2T%20extract/resultScreen.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class TextExtractorDashboard extends StatefulWidget {
  const TextExtractorDashboard({super.key});

  @override
  State<TextExtractorDashboard> createState() => _TextExtractorDashboardState();
}

class _TextExtractorDashboardState extends State<TextExtractorDashboard> {
  bool istext = false;
  bool notempty = false;
  bool isloaded = false;
  var text = "";
  String imagepath = "";
  File? _Image;

  final _adcontroller = Get.put(AdController());

  var _script = TextRecognitionScript.latin;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//backend part
  Future<File?> _cropImage({required File imagefile}) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: imagefile.path);
    if (croppedFile == null) {
      return null;
    } else {
      return File(croppedFile.path);
    }
  }

// backend
  Future<void> extractTextFromImage() async {
    setState(() {
      text = "";
      istext = false;
      isloaded = false;
      notempty = false;
    });
    final picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);
    print(imageFile);
    if (imageFile == null) return;
    File? img = File(imageFile.path);
    img = await _cropImage(imagefile: img);

    if (img == null) {
      // User canceled the image cropping
      return; // Exit the function
    }
    imagepath = img.path;
    setState(() {
      _Image = img;
      isloaded = true;
    });
    ExtractText();

    // final inputImage = InputImage.fromFilePath(_Image!.path);
    // final textRecognizer = GoogleMlKit.vision.textRecognizer();
    // final RecognizedText blocks = await textRecognizer.processImage(inputImage);

    // String extractedText = blocks.text;
    // if (extractedText != "") {
    //   setState(() {
    //     istext = true;
    //     text = extractedText;
    //   });
    // }
  }

  Future<void> extractTextFromCameraImage() async {
    setState(() {
      text = "";
      istext = false;
      isloaded = false;
      notempty = false;
    });
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;
    File? img = File(imageFile.path);
    img = await _cropImage(imagefile: img);
    if (img == null) {
      // User canceled the image cropping
      return; // Exit the function
    }
    imagepath = img.path;
    setState(() {
      _Image = img;
      isloaded = false;
    });
    ExtractText();
  }

  void ExtractText() async {
    final inputImage = InputImage.fromFilePath(_Image!.path);
    // final textRecognizer = text.vision.textRecognizer();
    final RecognizedText blocks =
        await _textRecognizer.processImage(inputImage);

    String extractedText = blocks.text;
    if (extractedText != "") {
      ToastM.message("Text Extracted");
      log("$extractedText");
      setState(() {
        text = extractedText;
      });
      Get.to(() => ResultScreen(
            text: text,
          ));
    } else {
      ToastM.message("Failed to Extract");
      setState(() {
        text = "";
      });
      Get.to(() => ResultScreen(
            text: text,
          ));
    }
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image to Snap"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Gap(10.h),
            GestureDetector(
                onTap: extractTextFromImage,
                child: Center(child: SvgPicture.asset("assets/Gallery.svg"))),
            Gap(20.h),
            GestureDetector(
                onTap: extractTextFromCameraImage,
                child: Center(child: SvgPicture.asset("assets/Camera.svg"))),
            Gap(10.h),
            Container(
                child: _adcontroller.isLoadedadb2.value
                    ? SizedBox(
                        height: _adcontroller.bannerAd2.size.height.toDouble(),
                        width: _adcontroller.bannerAd2.size.width.toDouble(),
                        child: AdWidget(ad: _adcontroller.bannerAd2),
                      )
                    : const SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: _adcontroller.nativeAd3 != null &&
              _adcontroller.isloadednative3.isTrue
          ? SafeArea(
              child: SizedBox(
                height: 85,
                child: AdWidget(ad: _adcontroller.nativeAd3!),
              ),
            )
          : null,
    );
  }
}
