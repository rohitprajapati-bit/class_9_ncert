import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:class_9_ncert/model/book.dart';
import 'package:class_9_ncert/pages/chapter_page.dart';
import 'package:class_9_ncert/utils/theme.dart';
import 'package:class_9_ncert/widget/bannerAdWidget.dart';
import 'package:class_9_ncert/utils/constent.dart';
import 'package:class_9_ncert/widget/book_widget.dart';

class SubjectPage extends StatefulWidget {
  final String subjectName;
  final List<Book> bookList;

  const SubjectPage({
    super.key,
    required this.bookList,
    required this.subjectName,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
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
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.subjectName,
          ),
          backgroundColor: AppColor.getBgColor(context)),
      body: Container(
        color: AppColor.getAppBarColor(context),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: widget.bookList.length,
                  itemBuilder: (context, index) {
                    Book book = widget.bookList[index];
                    return BookWidget(
                      book: book,
                      onBookClick: () {
                        Constant.adsCount++;
                        if ((Constant.appConfig?.showAds ?? false)&&(Constant.adsCount%2==0)) {
                          showInterstitialAd();
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChepterPage(
                                      pdfList: book.pdfLinks!,
                                      lessonsName: book.name!,
                                    )));
                      },
                      onFavTap: (isLiked) async {
                        book.favorite = !isLiked;

                        updatedFavouriteList(book);
                        if (isLiked) {
                          addRemoveFavourite('Removed from favourite');
                        } else {
                          addRemoveFavourite('Added to favourite');
                        }
                        return book.favorite;
                      },
                      showfavoriteIcon: true,
                    );
                  }),
            ),
            
            const Align(
              alignment: Alignment.bottomCenter,
              child: MyBannerAdWidget(),
            )
          ],
        ),
      ),
    );
  }

  void addRemoveFavourite(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
      ),
    );
  }

  void updatedFavouriteList(Book book) {
    Box<Book> bookBox = Hive.box<Book>('favoriteList');
    List<Book> storedList = bookBox.values.toList();

    int index = storedList.indexWhere((e) => e.id == book.id);
    if (index == -1) {
      bookBox.add(book);
    } else {
      bookBox.deleteAt(index);
    }
  }
}
