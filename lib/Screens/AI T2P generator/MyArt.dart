import 'dart:io';
import 'package:ai_text_to_photo_new/Screens/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../AdsController/AdsCOntroller.dart';

class Myart extends StatefulWidget {
  const Myart({Key? key}) : super(key: key);

  @override
  State<Myart> createState() => _MyartState();
}

class _MyartState extends State<Myart> {
  List<File> imglist = [];
  var album = "AI Images";
  int _selectedImageIndex = -1;

  final _adcontroller = Get.put(AdController());

  Future<void> _loadImages() async {
    Directory appDocDir =
        await Directory('/storage/emulated/0/Pictures/$album');
    List<FileSystemEntity> files = appDocDir.listSync();

    List<File> imageFiles = [];

    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.png')) {
        imageFiles.add(file);
      }
    }

    setState(() {
      imglist = imageFiles;
      print("imhages is ");
      print(imglist.length);
    });
  }

  void popImage(int index) {
    if (_selectedImageIndex != -1) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Dismiss the dialog on tap
            },
            child: Image.file(
              imglist[index],
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My gallery",
          style: TextStyle(fontFamily: "Poppins-Bold"),
        ),
      ),
      // backgroundColor: whiteClr,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: imglist.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 2,
                ),
                itemCount: imglist.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index; // Store the tapped index
                      });
                      popImage(index);
                      // openFullScreenImage(index);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.file(
                        imglist[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text("No Images Available")),
      ),
      bottomNavigationBar: Container(
          child: _adcontroller.isLoadedadb3.value
              ? SizedBox(
                  height: _adcontroller.bannerAd3.size.height.toDouble(),
                  width: _adcontroller.bannerAd3.size.width.toDouble(),
                  child: AdWidget(ad: _adcontroller.bannerAd3),
                )
              : const SizedBox()),
    );
  }
}
