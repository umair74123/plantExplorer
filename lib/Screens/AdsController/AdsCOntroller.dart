import 'dart:developer';

import 'package:ai_text_to_photo_new/Screens/utils/Adunits.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  late BannerAd bannerAd1;
  RxBool isLoadedadb1 = false.obs;

  late BannerAd bannerAd2;
  RxBool isLoadedadb2 = false.obs;

  late BannerAd bannerAd3;
  RxBool isLoadedadb3 = false.obs;

  late BannerAd bannerAd4;
  RxBool isLoadedadb4 = false.obs;

  late BannerAd bannerAd5;
  RxBool isLoadedadb5 = false.obs;

  late InterstitialAd interstitialAd;
  RxBool isLoaded = false.obs;

  late InterstitialAd interstitialAd2;
  RxBool isLoaded2 = false.obs;

  NativeAd? nativeAd1;
  RxBool isloadednative1 = false.obs;

  NativeAd? nativeAd2;
  RxBool isloadednative2 = false.obs;

  NativeAd? nativeAd3;
  RxBool isloadednative3 = false.obs;

  NativeAd? nativeAd4;
  RxBool isloadednative4 = false.obs;
  NativeAd? nativeAd5;
  RxBool isloadednative5 = false.obs;
  // Initialize interstitial ad
  AdController() {
    initInterstitialAd();
    initInterstitialAd2();
    initbannedAd1();
    initbannedAd2();
    initbannedAd3();
    // initbannedAd4();
    // initbannedAd5();
    nativeAd1 = loadnativeAd();
    nativeAd2 = loadnativeAd2();
    nativeAd3 = loadnativeAd3();
    nativeAd4 = loadnativeAd4();
    nativeAd5 = loadnativeAd5();
  }

  // Initialize interstitial ad
  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: RealADunit.interAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interstitialAd = ad;
        isLoaded.value = true;

        interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            isLoaded.value = false;
            initInterstitialAd(); // Load a new ad when the old one is dismissed
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            isLoaded.value = false;
            initInterstitialAd(); // Load a new ad if showing failed
          },
        );
      }, onAdFailedToLoad: (error) {
        interstitialAd.dispose();
      }),
    );
  }

  // Initialize interstitial ad
  void initInterstitialAd2() {
    InterstitialAd.load(
      adUnitId: RealADunit.interAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interstitialAd2 = ad;
        isLoaded2.value = true;

        interstitialAd2.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();

            isLoaded2.value = false;
            initInterstitialAd2(); // Load a new ad when the old one is dismissed
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            isLoaded2.value = false;
            initInterstitialAd2(); // Load a new ad if showing failed
          },
        );
      }, onAdFailedToLoad: (error) {
        interstitialAd2.dispose();
      }),
    );
  }

  void initbannedAd1() {
    bannerAd1 = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: RealADunit.bannerAdUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad1) {
            isLoadedadb1.value = true;
          },
          onAdFailedToLoad: (ad1, error) {
            ad1.dispose();
          },
          onAdWillDismissScreen: (ad) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    bannerAd1.load();
  }

  void initbannedAd2() {
    bannerAd2 = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: RealADunit.bannerAdUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad1) {
            isLoadedadb2.value = true;
          },
          onAdFailedToLoad: (ad1, error) {
            ad1.dispose();
          },
          onAdWillDismissScreen: (ad) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    bannerAd2.load();
  }

  void initbannedAd3() {
    bannerAd3 = BannerAd(
        size: AdSize.banner,
        adUnitId: RealADunit.bannerAdUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad1) {
            isLoadedadb3.value = true;
          },
          onAdFailedToLoad: (ad1, error) {
            ad1.dispose();
          },
          onAdWillDismissScreen: (ad) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    bannerAd3.load();
  }

  void initbannedAd4() {
    bannerAd4 = BannerAd(
        size: AdSize.banner,
        adUnitId: RealADunit.bannerAdUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad1) {
            isLoadedadb4.value = true;
          },
          onAdFailedToLoad: (ad1, error) {
            ad1.dispose();
          },
          onAdWillDismissScreen: (ad) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    bannerAd4.load();
  }

  void initbannedAd5() {
    bannerAd5 = BannerAd(
        size: AdSize.banner,
        adUnitId: RealADunit.bannerAdUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad1) {
            isLoadedadb5.value = true;
          },
          onAdFailedToLoad: (ad1, error) {
            ad1.dispose();
          },
        ),
        request: const AdRequest());

    bannerAd5.load();
  }

  //native ad
  NativeAd loadnativeAd() {
    return NativeAd(
        adUnitId: RealADunit.nativeAdUnit,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log("native ad loaded");
            isloadednative1.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          // Optional: Customize the ad's style
        ))
      ..load();
  }

  //native ad
  NativeAd loadnativeAd2() {
    return NativeAd(
        adUnitId: RealADunit.nativeAdUnit,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log("native ad loaded");
            isloadednative2.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          // Optional: Customize the ad's style
        ))
      ..load();
  }

  //native ad
  NativeAd loadnativeAd3() {
    return NativeAd(
        adUnitId: RealADunit.nativeAdUnit,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log("native ad loaded");
            isloadednative3.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          // Optional: Customize the ad's style
        ))
      ..load();
  }

  //native ad
  NativeAd loadnativeAd4() {
    return NativeAd(
        adUnitId: RealADunit.nativeAdUnit,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log("native ad loaded");
            isloadednative4.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          // Optional: Customize the ad's style
        ))
      ..load();
  }

  //native ad
  NativeAd loadnativeAd5() {
    return NativeAd(
        adUnitId: RealADunit.nativeAdUnit,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log("native ad loaded");
            isloadednative5.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          // Optional: Customize the ad's style
        ))
      ..load();
  }
}
