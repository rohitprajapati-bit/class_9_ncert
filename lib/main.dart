import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:class_9_ncert/model/book.dart';
import 'package:class_9_ncert/model/languag.dart';
import 'package:class_9_ncert/model/ncert.dart';
import 'package:class_9_ncert/model/pdfLink.dart';
import 'package:class_9_ncert/model/subject.dart';
import 'package:class_9_ncert/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(LanguageAdapter());
  Hive.registerAdapter(NcertAdapter());
  Hive.registerAdapter(PdfLinksAdapter());
  Hive.registerAdapter(SubjectsAdapter());
  await Hive.openBox<Book>('favoriteList');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Class 9 NCERT Books',

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.ubuntuTextTheme().copyWith(
          bodyMedium: GoogleFonts.ubuntu(textStyle: textTheme.bodyMedium),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),

      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      //   textTheme: GoogleFonts.ubuntuTextTheme().copyWith(
      //     bodyMedium: GoogleFonts.ubuntu(
      //         textStyle: textTheme.bodyMedium,),
      //   ),
      //   // scaffoldBackgroundColor: Colors.black87,
      // ),
      // themeMode: ThemeMode.light,
    );
  }
}
