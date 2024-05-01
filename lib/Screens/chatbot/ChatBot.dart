import 'package:ai_text_to_photo_new/Screens/AI%20T2P%20generator/apiservices.dart';
import 'package:ai_text_to_photo_new/Screens/AdsController/AdsCOntroller.dart';
import 'package:ai_text_to_photo_new/Screens/chatbot/ApiResponse.dart';
import 'package:ai_text_to_photo_new/Screens/chatbot/ChatController.dart';
import 'package:ai_text_to_photo_new/Screens/chatbot/MessageCard.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final _c = ChatController();
  final _adcontroller = Get.put(AdController());
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      backgroundColor: mainclr,
      appBar: AppBar(
        title: const Text("Chat with Texy"),
      ),

      //body
      body: Obx(() => Column(
            children: [
              Expanded(
                child: _c.list.isNotEmpty
                    ? ListView(
                        physics: const BouncingScrollPhysics(),
                        controller: _c.scrollC,
                        padding: EdgeInsets.only(
                            top: mq.height * .02, bottom: mq.height * .1),
                        children: _c.list
                            .map((e) => MessageCard(message: e))
                            .toList(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: SvgPicture.asset(
                                  "assets/Chat AI Placeholder robot.svg")),
                          const Center(
                              child: Text(
                                  "Hi, I am Texy. Your AI Chat assistant")),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(children: [
                  //text input field

                  Obx(
                    () => Flexible(
                      child: TextFormField(
                        controller: _c.textC,
                        textAlign: TextAlign.start,
                        onTapOutside: (e) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          fillColor: Colors.amber,
                          errorText:
                              _c.validate.value ? "Text Can't Be Empty" : null,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Ask me anything you want...",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                              borderSide: BorderSide(color: textClr)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                              borderSide: BorderSide(color: textClr)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                              borderSide: BorderSide(color: textClr)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                              borderSide: BorderSide(color: textClr)),
                        ),
                      ),
                    ),
                  ),
                  //for adding some space
                  const SizedBox(width: 8),

                  //  send button
                  SafeArea(
                      child: InkWell(
                          onTap: _c.askQuestion,
                          child: SvgPicture.asset("assets/Send.svg"))),
                ]),
              ),
              Gap(10.h)
            ],
          )),

      // ad
      bottomNavigationBar: _adcontroller.nativeAd2 != null &&
              _adcontroller.isloadednative2.isTrue
          ? SafeArea(
              child: SizedBox(
                height: 85,
                child: AdWidget(ad: _adcontroller.nativeAd2!),
              ),
            )
          : null,
    );
  }
}
