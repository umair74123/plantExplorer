import 'package:ai_text_to_photo_new/Screens/AI%20T2P%20generator/ImageGenerator.dart';
import 'package:ai_text_to_photo_new/Screens/I2T%20extract/TextExtractor.dart';
import 'package:ai_text_to_photo_new/Screens/ImageDescriberAI/ImagedescriberAi.dart';
import 'package:ai_text_to_photo_new/Screens/chatbot/ChatBot.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'AdsController/AdsCOntroller.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final _adcontroller = Get.put(AdController());
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Exit App',
                style: TextStyle(
                  color: blackClr,
                ),
              ),
              content: Text(
                'Do you want to exit the App?',
                style: TextStyle(
                  color: blackClr,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (_adcontroller.isLoaded2.value) {
                      await _adcontroller.interstitialAd2.show();
                    } else {
                      print("faild to load ad");
                    }
                    Navigator.of(context).pop(false);
                  },
                  //return false when click on "NO"
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: blackClr,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    SystemNavigator.pop();
                  },
                  //return true when click on "Yes"
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: blackClr,
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    var mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: mainclr,
            title: Text(
              "SnapText AI",
              style: GoogleFonts.iceberg(fontSize: 25.sp, color: whiteClr),
            ),
          ),
          backgroundColor: mainclr,
          body: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  flex: 0,
                  child: GestureDetector(
                    onTap: () => Get.to(() => ImageDescriber()),
                    child: Center(
                      child: Container(
                        decoration:
                            BoxDecoration(border: Border.all(color: whiteClr)),
                        child: Column(
                          children: [
                            Container(
                              height: mq.height * .20,
                              width: mq.width * .9,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  image: DecorationImage(
                                      image: AssetImage("assets/t2P.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                            Gap(10.h),
                            Text(
                              "Image Describer",
                              style: GoogleFonts.inter(
                                fontSize: 25.h,
                              ),
                            ),
                            Gap(10.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  flex: 0,
                  child: GestureDetector(
                    onTap: () => Get.to(() => TextExtractorDashboard()),
                    child: Center(
                      child: Container(
                        decoration:
                            BoxDecoration(border: Border.all(color: whiteClr)),
                        child: Column(
                          children: [
                            Container(
                              height: mq.height * .20,
                              width: mq.width * .9,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  image: DecorationImage(
                                      image: AssetImage("assets/I2t.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                            Gap(10.h),
                            Text(
                              "Snap to Text",
                              style: GoogleFonts.inter(
                                fontSize: 25.h,
                              ),
                            ),
                            Gap(10.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _adcontroller.nativeAd1 != null &&
                  _adcontroller.isloadednative1.isTrue
              ? SafeArea(
                  child: SizedBox(
                    height: 85,
                    child: AdWidget(ad: _adcontroller.nativeAd1!),
                  ),
                )
              : null,
          floatingActionButton: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Chat with Texy"),
              SizedBox(
                width: 20.w,
              ),
              InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Get.to(() => ChatBot()),
                  child: SvgPicture.asset("assets/Chat with AI Icon.svg")),
            ],
          ),
        ),
      ),
    );
  }
}
