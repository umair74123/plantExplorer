import 'dart:developer';

import 'package:ai_text_to_photo_new/Screens/chatbot/ApiResponse.dart';
import 'package:ai_text_to_photo_new/Screens/chatbot/MessageModel.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final textC = TextEditingController();

  final scrollC = ScrollController();

  final list = <Message>[].obs;
  RxBool validate = false.obs;

  Future<void> askQuestion() async {
    validate.value = textC.text.trim().isEmpty;
    log("${validate.value}");
    if (!validate.value) {
      //user
      list.add(Message(msg: textC.text, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      // _scrollDown();

      final res = await APIs.makeGeminiRequest(textC.text);
      textC.text = '';
      //ai bot
      list.removeLast();
      list.add(Message(msg: res, msgType: MessageType.bot));
      _scrollDown();
    }
  }

  //for moving to end message
  void _scrollDown() {
    scrollC.animateTo(scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
