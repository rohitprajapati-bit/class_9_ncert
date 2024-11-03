import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:class_9_ncert/utils/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  final String pdfLink;
  const PdfView({
    super.key,
    required this.pdfLink,
  });

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  bool isLoading = true;
  bool isRotate = false;
  Future<File>? fileData;

  Future<File> _downloadFile(BuildContext context, String url) async {
    var httpClient = HttpClient();
    try {
      final filename = url.split('/').last;
      print("download started");
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir =
          await getTemporaryDirectory(); 
      File file = await getSaveDirPath(url);
      await file.writeAsBytes(bytes);
      print('downloaded file path = ${file.path}');
      isLoading = false;
      setState(() {});
      return file;
    } catch (error) {
      print('pdf downloading error = $error');
      isLoading = false;
      return File('');
    }
  }

  Future<File> getSaveDirPath(String url) async {
    try {
      final filename = url.split('/').last;
      final dir =
          await getTemporaryDirectory(); //(await getApplicationDocumentsDirectory()).path;
      File file = File('${dir.path}/$filename');
      return file;
    } catch (e) {
      return File('');
    }
  }

  /// Displays the error message.
  void showErrorDialog(BuildContext context, String error, String description) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _toggelScreenRotation() {
    setState(() {
      if (isRotate) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        isRotate = false;
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
        isRotate = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  void downloadPdf() async {
    fileData = _downloadFile(context, widget.pdfLink);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FutureBuilder<File>(
            future: fileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SfPdfViewer.file(
                  snapshot.data ?? File(''),
                  onDocumentLoaded: (details) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onDocumentLoadFailed: (details) {
                    showErrorDialog(
                        context, details.error, details.description);
                  },
                );
              }
              return const SizedBox.shrink();
            }),
        if (isLoading)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animation/loading.json'),
              Text(
                " Please Wait..",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
            ],
          ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: FloatingActionButton(
              backgroundColor: AppColor.getBgColor(context),
              heroTag: "cancel",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        Visibility(
          visible: !isLoading,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 10),
              child: FloatingActionButton(
              backgroundColor: AppColor.getBgColor(context),
                heroTag: "rotate",
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  _toggelScreenRotation();
                },
                child: const Icon(Icons.rotate_right),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
