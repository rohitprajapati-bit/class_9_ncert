import 'package:flutter/foundation.dart';
import 'package:class_9_ncert/model/appConfig.dart';

class Constant {
  static const String Base_Url = "https://avtechky.in/ncert_books/";
  static const String appConfigUrl =
      'https://avtechky.in/ncert_books/ncert_config/class_9/app_config.php';
  static const String _bannerIdLive = 'ca-app-pub-8079043675555252/3421157330';
  static const String _bannerIdDebug = 'ca-app-pub-3940256099942544/6300978111';

  static const String _interstitialAdUnitIdLive =
      'ca-app-pub-8079043675555252/8112308861';
  static const String _interstitialAdUnitIdDebug =
      'ca-app-pub-3940256099942544/1033173712';

  static const String nativeAdUnitIdLive = '';
  static const String nativeAdUnitIdDebug =
      'ca-app-pub-3940256099942544/2247696110';
  static const String bannerUnitId =
      kDebugMode ? _bannerIdDebug : _bannerIdLive;
  static const String interstitialUnitId =
      kDebugMode ? _interstitialAdUnitIdDebug : _interstitialAdUnitIdLive;
  static AppConfig? appConfig;
  static int adsCount = 0;
}
