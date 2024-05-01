import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:ai_text_to_photo_new/Screens/AI%20T2P%20generator/MyArt.dart';
import 'package:ai_text_to_photo_new/Screens/AI%20T2P%20generator/apiservices.dart';
import 'package:ai_text_to_photo_new/Screens/AI%20T2P%20generator/gotgrow.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Messages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_plus/share_plus.dart';

import '../AdsController/AdsCOntroller.dart';

class ImageGenerator extends StatefulWidget {
  const ImageGenerator({super.key});

  @override
  State<ImageGenerator> createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  final textController = TextEditingController();
  String imagesize = '512x512';

  String? image = '';
  String? assetImage = "assets/FinalLogo.png";
  var isLoaded = false;
  var gloaded = false;
  ScreenshotController screenshotController = ScreenshotController();

  final _adcontroller = Get.put(AdController());
  double progress = 0.0;

  var _validate = false;

//download image
  gallerySaver() async {
    var album = "AI Images";
    try {
      await screenshotController
          .capture(delay: const Duration(milliseconds: 100), pixelRatio: 1.0)
          .then((Uint8List? img) async {
        const filename = 'AI_Image.png';
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$filename');

        // Create a file to store the generated image
        await file.writeAsBytes(img!.buffer.asUint8List());

        await GallerySaver.saveImage(file.path,
            albumName: album); // Save the image to gallery
        ToastM.message2("Image saved to galley");
        // log("Image saved to galley");
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // ToastM.message("'Failed to save image'");
    }
  }

// share function
  shareImage() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        const filename = "Share.png";
        final imgpath = await File("$directory/$filename").create();
        await imgpath.writeAsBytes(img);
        Share.shareFiles([imgpath.path], text: "");
      } else {
        if (kDebugMode) {
          print("unable to screenshot an image");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainclr,
      appBar: AppBar(
        backgroundColor: mainclr,
        title: Text("Text to Snap", style: GoogleFonts.inter(color: whiteClr)),
        actions: [
          InkWell(
              onTap: () => Get.to(() => const Myart()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset("assets/folder icon.svg"),
              )),
          Gap(10.h),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Column(
                children: [
                  TextFormField(
                    onTapOutside: (e) => FocusScope.of(context).unfocus(),
                    controller: textController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Color.fromRGBO(158, 158, 158, 1)),
                        label: const Text("Enter text here"),
                        errorText: _validate ? "Text Can't Be Empty" : null,
                        border: const OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      setState(() {
                        _validate = textController.text.isEmpty;
                        log("${_validate}");
                      });
                      if (!_validate) {
                        setState(() {
                          gloaded = true;
                        });

                        ToastM.message("Generating image, please wait");
                        // setState(() {
                        //   isLoaded = true;
                        //   gloaded = false;
                        // });

                        image = await API.generateImage(
                            textController.text, imagesize);
                        print("api called");
                        if (image != null) {
                          setState(() {
                            isLoaded = true;
                            gloaded = false;
                          });
                          ToastM.message("Image generated");

                          Future.delayed(
                            Duration(seconds: 3),
                            () {
                              if (_adcontroller.isLoaded.value) {
                                _adcontroller.interstitialAd.show();
                              } else {
                                print("failed to  load");
                              }
                            },
                          );
                        } else {
                          ToastM.message("Something went wrong, try again");
                          setState(() {
                            isLoaded = false;
                            gloaded = false;
                          });
                        }
                      } else {
                        ToastM.message("Please pass the query first");
                      }
                    },
                    child: gloaded
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/Generating.svg",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Generating",
                                    style: TextStyle(
                                        color: blackClr,
                                        fontSize: 20.h,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  WidgetDotGrow(color: blackClr)
                                ],
                              ),

                              // Positioned(
                              //   right: 10,
                              //   child: Container(
                              //       width: 10,
                              //       height: 5,
                              //       alignment: Alignment.center,
                              //       child:
                              // ),
                              // ),
                            ],
                          )
                        : SvgPicture.asset(
                            "assets/Generate.svg",
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            // Gap(10.h),

            // Gap(10.h),

            //After Images is generated
            isLoaded
                ? Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Result",
                            style: TextStyle(
                              fontSize: 20.sp,
                            )),
                        TextButton(
                            onPressed: () {
                              textController.text = "";

                              setState(() {
                                isLoaded = false;
                                gloaded = false;
                              });
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(color: textClr),
                            ))
                      ],
                    ))
                : const SizedBox(),

            //Image Preview
            isLoaded
                ? Expanded(
                    flex: 2,
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Screenshot(
                          controller: screenshotController,
                          child: Image.network(
                            image!,
                            fit: BoxFit.contain,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),

                          //     Image.asset(
                          //   "assets/FinalLogo.png",
                          //   fit: BoxFit.contain,
                          // ),
                        )),
                  )
                : SizedBox(),

            //Buttons (save share etc)
            isLoaded
                ? Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              shareImage();
                            },
                            child: SvgPicture.asset("assets/share.svg")),
                        InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              gallerySaver();
                            },
                            child: SvgPicture.asset("assets/Save.svg")),
                        InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              textController.text = "";

                              setState(() {
                                isLoaded = false;
                                gloaded = false;
                              });
                            },
                            child: SvgPicture.asset("assets/regenrate.svg")),
                      ],
                    ))
                : const SizedBox(),

//ad section
            !isLoaded
                ? Center(
                    child: Container(
                        child: _adcontroller.isLoadedadb1.value
                            ? SizedBox(
                                height: _adcontroller.bannerAd1.size.height
                                    .toDouble(),
                                width: _adcontroller.bannerAd1.size.width
                                    .toDouble(),
                                child: AdWidget(ad: _adcontroller.bannerAd1),
                              )
                            : const SizedBox()),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
