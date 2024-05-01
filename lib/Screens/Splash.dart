import 'dart:developer';

import 'package:ai_text_to_photo_new/Screens/Dashboard.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Adunits.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:ai_text_to_photo_new/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? openAd;

Future<void> loadAd() async {
  await AppOpenAd.load(
      adUnitId: RealADunit.OpenAppAdUnit,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        log('ad is loaded');
        openAd = ad;
        openAd!.show();
      }, onAdFailedToLoad: (error) {
        log('ad faileddd to load $error');
      }),
      orientation: AppOpenAd.orientationPortrait);
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadAd();
    _nevigatetohome();
  }

  _nevigatetohome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DashBoard()));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteClr,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Material(
              elevation: 10,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/AppIcon.png",
                fit: BoxFit.fill,
                height: 200,
              ),
            ),
          ),
          // Image.asset(
          //   "assets/goldIcon.png",
          //   height: 120,
          // ),
          Positioned(
            top: size.height * .65,
            child: Center(
              child: Text(appname,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
