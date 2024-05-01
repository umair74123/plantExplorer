import 'package:ai_text_to_photo_new/Screens/AdsController/AdsCOntroller.dart';
import 'package:ai_text_to_photo_new/Screens/Dashboard.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    final _adcontroller = Get.put(AdController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainclr,
        body: Stack(
          alignment: Alignment.topCenter,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/Splash Photo.png",
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: mq.height * .075,
              child: SizedBox(
                height: 49.h,
                // width: 219.w,
                child: Text(
                  "SnapText AI",
                  style: GoogleFonts.iceberg(fontSize: 40.sp),
                ),
              ),
            ),
            Positioned(
              bottom: mq.height * .070,
              child: GestureDetector(
                onTap: () => Get.to(() => DashBoard()),
                child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: SvgPicture.asset("assets/Start.svg")),
              ),
            )
          ],
        ),
        bottomNavigationBar: _adcontroller.nativeAd5 != null &&
                _adcontroller.isloadednative5.isTrue
            ? SafeArea(
                child: SizedBox(
                  height: 85,
                  child: AdWidget(ad: _adcontroller.nativeAd5!),
                ),
              )
            : null,
      ),
    );
  }
}
