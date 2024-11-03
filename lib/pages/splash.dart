import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:class_9_ncert/model/appConfig.dart';
import 'package:class_9_ncert/model/ncert.dart';
import 'package:class_9_ncert/pages/home_page.dart';
import 'package:class_9_ncert/utils/constent.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Ncert? ncert;

  loadConfig() async {
    final response = await get(Uri.parse(Constant.appConfigUrl));
    if (response.statusCode == 200) {
      print(response.body);
      final json = jsonDecode(response.body);
      final data = AppConfig.fromJson(json);
      Constant.appConfig = data;
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      ncert: ncert,
                    )),
            (_) => false);
      });
    });

    loadConfig();
    loadbook();
  }

  Future<void> loadbook() async {
    String jsonString = await rootBundle.loadString('assets/book.json');
    final data = jsonDecode(jsonString);
    ncert = Ncert.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF3F5FF),
        // color:const Color.fromARGB(255, 47, 126, 192),
        // decoration: const BoxDecoration(
        // image: DecorationImage(
        //     image: AssetImage("assets/images/main_image.png"),
        //     fit: BoxFit.fill),
        // ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Lottie.asset('assets/animation/splash_2_animation.json'),
            ),
            const Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 390,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      " CLASS 9th\n NCERT BOOKS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
