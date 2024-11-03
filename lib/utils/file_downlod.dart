import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileDownload {
  bool isSuccess = false;

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

  void startDownloading(BuildContext context, String baseUrl, String fileName,
      Function okCallback) async {
    var httpClient = new HttpClient();

    try {
      var request = await httpClient.getUrl(Uri.parse(baseUrl));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir =
          await getTemporaryDirectory(); //(await getApplicationDocumentsDirectory()).path;
      File? file = await getSaveDirPath(baseUrl);
      await file.writeAsBytes(bytes);
      Navigator.pop(context);
      sharePdfFile(file.path ?? '');
    } catch (e) {
      Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Please Connected to Internet to Download'),
            );
          });

      print("Exception$e");
      isSuccess = false;
    }
  }

  sharePdfFile(String pdfPath) {
    Share.shareXFiles([XFile(pdfPath)]);
  }
}
