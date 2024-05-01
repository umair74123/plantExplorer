import 'package:ai_text_to_photo_new/Screens/AI%20T2P%20generator/gotgrow.dart';
import 'package:ai_text_to_photo_new/Screens/chatbot/MessageModel.dart';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    const r = Radius.circular(15);

    return message.msgType == MessageType.bot

        //bot
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                const SizedBox(height: 2),
                GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Copy to clipboard?",
                              style: TextStyle(color: blackClr)),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: message.msg));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied to clipboard'),
                                  ),
                                );
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              icon: Icon(Icons.copy),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(maxWidth: mq.width * .6),
                    margin: EdgeInsets.only(
                        bottom: mq.height * .02, left: mq.width * .02),
                    padding: EdgeInsets.symmetric(
                        vertical: mq.height * .01, horizontal: mq.width * .02),
                    decoration: BoxDecoration(
                        border: Border.all(color: textClr),
                        borderRadius: const BorderRadius.only(
                            topLeft: r, topRight: r, bottomRight: r)),
                    child: message.msg.isEmpty
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: WidgetDotGrow(color: whiteClr))
                        : Text(
                            message.msg,
                            textAlign: TextAlign.start,
                          ),
                  ),
                ),
              ])

        //user
        : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            //
            Container(
                constraints: BoxConstraints(maxWidth: mq.width * .6),
                margin: EdgeInsets.only(
                    bottom: mq.height * .02, right: mq.width * .02),
                padding: EdgeInsets.symmetric(
                    vertical: mq.height * .01, horizontal: mq.width * .02),
                decoration: BoxDecoration(
                    color: textClr,
                    border: Border.all(color: blackClr),
                    borderRadius: const BorderRadius.only(
                        topLeft: r, topRight: r, bottomLeft: r)),
                child: Text(
                  message.msg,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: blackClr),
                )),

            // const CircleAvatar(
            //   radius: 18,
            //   backgroundColor: Colors.white,
            //   child: Icon(Icons.person, color: Colors.blue),
            // ),

            const SizedBox(width: 6),
          ]);
  }
}
