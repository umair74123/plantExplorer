import 'package:ai_text_to_photo_new/Screens/Dashboard.dart';
import 'package:ai_text_to_photo_new/Screens/ImageDescriberAI/ImagedescriberAi.dart';
import 'package:ai_text_to_photo_new/Screens/Onboarding.dart';
import 'package:ai_text_to_photo_new/Screens/Splash.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appname = 'SnapTextAI';
int? initScreen;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // log("$width");
    // log("$height");
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: appname,
          // You can use the library anywhere in the app even in theme

          theme: ThemeData(
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              titleTextStyle:
                  GoogleFonts.inter(color: whiteClr, fontSize: 25.sp),
              backgroundColor: blackClr,
            ),
            scaffoldBackgroundColor: mainclr,
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018
                .apply(fontSizeFactor: 1.sp, bodyColor: Colors.white),
          ),
          initialRoute:
              initScreen == 0 || initScreen == null ? "onboard" : "home",
          routes: {
            "home": (context) => Splash(),
            "onboard": (context) => Onboarding(),
          },
        );
      },
      child: const DashBoard(),
    );
  }
}
