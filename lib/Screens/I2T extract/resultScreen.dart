import 'package:ai_text_to_photo_new/Screens/AdsController/AdsCOntroller.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    final _adcontroller = Get.put(AdController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image To Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Result",
            style: TextStyle(fontSize: 25.sp),
          ),
          Gap(20.h),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color.fromARGB(103, 117, 116, 116),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: whiteClr)),
            child: text.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Text(
                            textDirection: TextDirection.ltr,
                            text,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                    "No data",
                    style: TextStyle(color: whiteClr),
                  )),
          ),
          Gap(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Share.share(text);
                  },
                  child: SvgPicture.asset("assets/share.svg")),
              InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('copied to clipboard'),
                      ),
                    );
                  },
                  child: SvgPicture.asset("assets/copy.svg")),
            ],
          )
        ]),
      ),
      bottomNavigationBar: _adcontroller.nativeAd4 != null &&
              _adcontroller.isloadednative4.isTrue
          ? SafeArea(
              child: SizedBox(
                height: 85,
                child: AdWidget(ad: _adcontroller.nativeAd4!),
              ),
            )
          : null,
    );
  }
}
