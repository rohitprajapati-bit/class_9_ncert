import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:class_9_ncert/model/ncert.dart';
import 'package:class_9_ncert/model/subject.dart';
import 'package:class_9_ncert/pages/favorite_page.dart';
import 'package:class_9_ncert/utils/theme.dart';
import 'package:class_9_ncert/utils/constent.dart';
import 'package:class_9_ncert/widget/categories_widget.dart';
import 'package:class_9_ncert/widget/drawer_widget.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  final Ncert? ncert;
  const HomePage({super.key, required this.ncert});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScreenshotController screenshotController = ScreenshotController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Subjects> _foundSubjects = [];
  List<Subjects> allSubject = [];
  InterstitialAd? interstitialAd;
  int numInterstitialLoadAttempts = 0;
  late TabController tabController;

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
    loadbook();
    createInterstitialAd();
    checkUpdateApp();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {});
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> loadbook() async {
    if (widget.ncert == null) {
      String jsonString = await rootBundle.loadString('assets/book.json');
      final data = jsonDecode(jsonString);
      Ncert ncert = Ncert.fromJson(data);

      setState(() {
        allSubject = ncert.getAllSubject();
        _foundSubjects = allSubject;
      });
    } else {
      setState(() {
        allSubject = widget.ncert?.getAllSubject();
        _foundSubjects = allSubject;
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Subjects> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSubject;
    } else {
      results = allSubject
          .where((subject) => subject.type!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundSubjects = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: DrawerWidget(screenshotController:screenshotController ,),
        ),
        appBar: AppBar(
          backgroundColor: AppColor.getBgColor(context),
          title: Text(
            "Class 9 NCERT Books",
            style: TextStyle(color: AppColor.getIconColor(context)),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.window,
                color: AppColor.getIconColor(context),
              )),
          actions: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Notification Not Found'),
                  ),
                );
              },
              icon: Icon(
                Icons.notifications,
                color: AppColor.getIconColor(context),
              ),
            )
          ],
        ),
        body: allSubject.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Screenshot(
              controller: screenshotController,
              child: Container(
                  color: AppColor.getAppBarColor(context),
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 25, top: 25),
                                    height: 280,
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(30),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/main_image.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "Let' learn together!",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.getBgColor(
                                                      context)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: TextField(
                                            autofocus: false,
                                            onChanged: (value) =>
                                                _runFilter(value),
                                            decoration: InputDecoration(
                                              hintText: 'Search for topic...',
                                              filled: true,
                                              fillColor:
                                                  AppColor.getBgColor(context),
                                              suffixIcon:
                                                  const Icon(Icons.search),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Transform.rotate(
                                      angle: 340,
                                      // child: SvgPicture.asset(
                                      //   "assets/icons_sub/mortarboard-svgrepo-com.svg",
                                      //   width: 90,
                                      // ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Lottie.asset(
                                            'assets/animation/homeScreen_animation.json',
                                            height: 220),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TabBar(
                                controller: tabController,
                                physics: const ClampingScrollPhysics(),
                                tabs: const [
                                  Tab(
                                    text: 'Categories',
                                  ),
                                  Tab(
                                    text: 'Favorite',
                                  )
                                ],
                                labelStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                unselectedLabelStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.getTextColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(controller: tabController, children: [
                      CategoriesWidget(
                          foundSubjects: _foundSubjects,
                          showInterstitialAd: showInterstitialAd),
                      const FavoritePage()
                    ]),
                    // const Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "Categories",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 20,
                    //             backgroundColor: Colors.grey),
                    //       ),
                    //       SizedBox(
                    //         width: 15,
                    //       ),
                    //       Text(
                    //         "Favorites",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 20,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
              
                    // MyBannerAdWidget()
                  ),
                ),
            ));
  }

  void checkUpdateApp() {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {}
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }
}
