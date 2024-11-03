import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  final ScreenshotController screenshotController;
  const DrawerWidget({super.key, required this.screenshotController});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Uri privacy_policy =
      Uri.parse('https://avtechky.in/ncert_books/privacy_policy.html');
  final Uri useFullApps = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.avtechky.ncert_books');

  final Uri useFullApp_Class_12 = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.avtechky.ncert_12_class');
      final Uri useFullApp_Class_10 = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.avtechky.class_10_ncert');
      
  String appLink =
      'https://play.google.com/store/apps/details?id=com.avtechky.class_10_ncert';

  Future<void> _launchUrl() async {
    if (!await launchUrl(privacy_policy)) {
      throw Exception('Could not launch $privacy_policy');
    }
  }

  Future<void> _useFullApps() async {
    if (!await launchUrl(useFullApps)) {
      throw Exception('Could not launch $useFullApps');
    }
  }

  Future<void> _useFullApp_Class_12() async {
    if (!await launchUrl(useFullApp_Class_12)) {
      throw Exception('Could not launch $useFullApp_Class_12');
    }
  }
  Future<void> _useFullApp_Class_10() async {
    if (!await launchUrl(useFullApp_Class_10)) {
      throw Exception('Could not launch $useFullApp_Class_10');
    }
  }

  void _sendEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nagendra.prajapati@avtechky.in',
      // queryParameters: {'subject': 'CallOut user Profile', 'body': ''},
    );
    launchUrl(emailLaunchUri);
  }

  void appRate() {
    const appId = "com.avtechky.class_9_ncert";
    launchUrl(
      Uri.parse("market://details?id=$appId"),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<String> versionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  Future<void> _takeScreenshotAndShare() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = '$directory/screenshot.png';
    widget.screenshotController.capture().then((image) async {
      if (image != null) {
        final imagePath = File(fileName);
        await imagePath.writeAsBytes(image);

        // Share the screenshot and app link
        XFile xfile = XFile(fileName);
        Share.shareXFiles([xfile], text: 'Download this app:');
        Share.shareXFiles([xfile], text: 'Download this app:$appLink');
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    versionApp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    "Class 9 NCERT Books",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              const SizedBox(
                height: 20,
              ),
              // const ListTile(
              //     title: Text("Dark Mode"),
              //     leading: Padding(
              //       padding: EdgeInsets.only(left: 5),
              //       child: Icon(
              //         BoxIcons.bxs_moon,
              //         color: Colors.blue,
              //       ),
              //     )),
              ListTile(
                  onTap: _launchUrl,
                  title: const Text("Privacy Policy"),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      FontAwesome.lock_solid,
                      color: Colors.red,
                    ),
                  )),
              ListTile(
                  onTap: _sendEmail,
                  title: const Text("Feedback for Improving App"),
                  leading: Brand(
                    Brands.mail,
                  )),
              ListTile(
                  onTap: appRate,
                  title: const Text("RATE IT : Motivates Us"),
                  leading: Brand(
                    Brands.google_play,
                  )),
              // ListTile(
              //     onTap: _takeScreenshotAndShare,
              //     title: const Text("Share this App"),
              //     leading: Icon(
              //       Bootstrap.share,
              //       color: Colors.blue,
              //     )),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Useful Apps for NCERT Books"),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                  onTap: _useFullApps,
                  title: const Text("NCERT All Class Books"),
                  leading: Image.network(
                    'https://play-lh.googleusercontent.com/ZBgaGLcuZG9Ml6Eh917TauUzy8qRHTQixlT3CyUNVYR-uzJj-n4Cck6uPATjEjOVu7bd=w240-h480-rw',
                    height: 30,
                    width: 30,
                  )),
              ListTile(
                  onTap: _useFullApp_Class_12,
                  title: const Text("Class 12 NCERT Books"),
                  leading: Image.network(
                    'https://play-lh.googleusercontent.com/gLanQpgXCkKsPwg1i1wc4Z4sOjGB3nQYezuyhoo66f9EDDb55OgnPxFjXQgBwhVLpw=w240-h480-rw',
                    height: 30,
                    width: 30,
                  )),
                    ListTile(
                  onTap: _useFullApp_Class_10,
                  title: const Text("Class 10 NCERT Books"),
                  leading: Image.network(
                    'https://play-lh.googleusercontent.com/Fzc6PM5ShxC6cHzwzWTInwQRuWwn1xvexS9qg4w6wkzUzYBzsvWrGau8iJvhPZgS_NY=w240-h480-rw',
                    height: 30,
                    width: 30,
                  )),
            ],
          ),
        ),
        FutureBuilder(
            future: versionApp(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Version ${snapshot.data!}');
              }
              return const SizedBox.shrink();
            }),
        const SizedBox(
          height: 10,
        )
      ],
    ));
  }
}
