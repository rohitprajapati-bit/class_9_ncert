import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:class_9_ncert/model/pdfLink.dart';
import 'package:class_9_ncert/pages/pdf_view_page.dart';
import 'package:class_9_ncert/utils/theme.dart';
import 'package:class_9_ncert/widget/bannerAdWidget.dart';
import 'package:class_9_ncert/utils/constent.dart';
import 'package:class_9_ncert/utils/downlod_dailog.dart';

class ChepterPage extends StatefulWidget {
  final String lessonsName;
  final List<PdfLinks> pdfList;
  const ChepterPage(
      {super.key, required this.pdfList, required this.lessonsName});

  @override
  State<ChepterPage> createState() => _ChepterPageState();
}

class _ChepterPageState extends State<ChepterPage> {
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

  void showInterstitialAd({Function()? onAdClosed}) {
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
        if (onAdClosed != null) {
          onAdClosed();
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
        if (onAdClosed != null) {
          onAdClosed();
        }
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
      body: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white24
                // image: DecorationImage(
                // image: AssetImage(
                //   "assets/animation/jump_animation.json",
                // ),
                // fit: BoxFit.cover,
                // ),
                ),
            child: Lottie.asset('assets/animation/jump_animation.json'),
          ),
          Column(
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            AppColor.getChepterBgcolor(context), // Shadow color
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(
                            0, -5), // Negative Y offset to push shadow upward
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.lessonsName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.getTextColor(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: widget.pdfList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                    // height: 5,
                                    ),
                            itemBuilder: (context, index) {
                              PdfLinks pdfLinks = widget.pdfList[index];

                              return InkWell(
                                onTap: () {
                                  Constant.adsCount++;
                                  if ((Constant.appConfig?.showAds ?? false) &&
                                      (Constant.adsCount % 2 == 0)) {
                                    showInterstitialAd();
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PdfView(
                                              pdfLink:
                                                  '${Constant.Base_Url}${pdfLinks.link}')));
                                },
                                child: Column(
                                  children: [
                                    Card(
                                      elevation: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor.getBgColor(context),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 15),
                                          title: Text(
                                            '${pdfLinks.name}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                                '${"Unit"} ${pdfLinks.id! + 1}'),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.download),
                                            onPressed: () async {
                                              if (Constant.appConfig?.showAds ??
                                                  false) {
                                                showInterstitialAd(
                                                  onAdClosed: () async {
                                                    downloadFile(pdfLinks);
                                                  },
                                                );
                                              } else {
                                                downloadFile(pdfLinks);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: Constant.appConfig?.showAds ?? false,
                          child: const SizedBox(
                            height: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: FloatingActionButton(
                backgroundColor: AppColor.getBgColor(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: MyBannerAdWidget(),
          )
        ],
      ),
    );
  }

  String coverNameTofileName(String name) {
    return name.toLowerCase().replaceAll(' ', '_').replaceAll(':', '');
  }

  void downloadFile(PdfLinks pdfLinks) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogcontext) {
          return DownloadProgressDialog(
            baseUrl: '${Constant.Base_Url}${pdfLinks.link}',
            fileName: coverNameTofileName('${pdfLinks.name}.pdf'),
          );
        });
  }
}
