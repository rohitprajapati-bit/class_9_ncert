import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:class_9_ncert/model/book.dart';
import 'package:class_9_ncert/pages/chapter_page.dart';
import 'package:class_9_ncert/utils/constent.dart';
import 'package:class_9_ncert/utils/utility.dart';
import 'package:class_9_ncert/widget/book_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  InterstitialAd? interstitialAd;
  int numInterstitialLoadAttempts = 0;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Constant.interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts < 3) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  @override
  void initState() {
    super.initState();
    createInterstitialAd();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final utility = Utility();
    List<Book> favoriteList = utility.getFavList();
    return Padding(
        padding: const EdgeInsets.all(20),
        child: favoriteList.isEmpty
            ? const Center(
                child: Text(
                  'Your favorite list is empty!',
                  // style: TextStyle(fontSize: 20),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  final favoriteBook = favoriteList[index];
                  return BookWidget(
                    book: favoriteBook,
                    onBookClick: () {
                      Constant.adsCount++;
                        if ((Constant.appConfig?.showAds ?? false)&&(Constant.adsCount%2==0)) {
                          showInterstitialAd();
                        }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChepterPage(
                                    pdfList: favoriteBook.pdfLinks!,
                                    lessonsName: favoriteBook.name!,
                                  )));
                    },
                    showfavoriteIcon: false,
                  );
                }));
  }
}
