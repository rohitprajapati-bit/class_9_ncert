import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:class_9_ncert/utils/file_downlod.dart';

class DownloadProgressDialog extends StatefulWidget {
  final String baseUrl;
  final String fileName;

  const DownloadProgressDialog(
      {super.key, required this.baseUrl, required this.fileName});
  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double progress = 0.0;

  @override
  void initState() {
    _startDownload();
    super.initState();
  }

  void _startDownload() {
    FileDownload().startDownloading(context, widget.baseUrl, widget.fileName,
        (recivedBytes, totalBytes) {
      setState(() {
        progress = recivedBytes / totalBytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();
    return AlertDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: LottieBuilder.asset(
          'assets/animation/waiting.json',
          height: 200,
        )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            "Downloading",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
        // LinearProgressIndicator(
        //   value: progress,
        //   borderRadius: BorderRadius.circular(20),
        //   backgroundColor: Colors.grey,
        //   color: Colors.blue,
        //   minHeight: 10,
        // ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: Text(
        //     "$downloadingProgress %",
        //   ),
        // )
      ],
    ));
  }
}
