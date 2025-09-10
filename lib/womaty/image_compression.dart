import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompression extends StatefulWidget {
  const ImageCompression({super.key});

  @override
  State<ImageCompression> createState() => _ImageCompressionState();
}

class _ImageCompressionState extends State<ImageCompression> {
  Future<File?> imageCompression({required String inputPath, required String outputPath, int quality = 7}) async {
    Stopwatch stopwatch = Stopwatch()..start();
    final dir = await getTemporaryDirectory();
    final outputPath = '${dir.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.webp';

    // higher compression quality is equal to greater compression and low quality.
    // String command = '-i $inputPath -q:v $quality $outputPath';

    // scale the image to 1080 resolution and compression quality range to 50.
    // The below command is used by Instagram according to chatGPT.
    String command = "-i $inputPath -vf \"scale='min(1080,iw)':-1\" -q:v 50 -map_metadata -1 $outputPath";


    print("command: $command");
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    if (returnCode?.isValueSuccess() ?? false) {
      print("✅ Compression successful: ");

      final file = File(outputPath);
      file.stat().then((value) {
        print("💿 Size of compressed file: ${value.size / 1000000} MB");
      });
      return file;
    } else {
      print("❌ Compression failed");
    }
    stopwatch.stop();
    print("Stopwatch: ${stopwatch.elapsed}");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            CupertinoButton(
              onPressed: () {
                FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false).then((value) async {
                  if (value != null) {
                    print("value: ${value.files.first.size / 1000000} MB");

                    // final dir = await getTemporaryDirectory();
                    // final outputPath = '${dir.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.jpg';
                    //
                    // File savedFile = await File(value.files.first.path!).copy(outputPath);
                    // print("savedFile.path: ${savedFile.path}");

                    final dir = await getTemporaryDirectory();
                    final file = await imageCompression(inputPath: value.files.first.path!, outputPath: '${dir.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.jpg', quality: 47);

                    // String inputPath = value.files.first.path!;
                    // int q = 7;
                    // double compressFileSize = value.files.first.size / 1000000;
                    // while (compressFileSize > 0.5) {
                    //   final dir = await getTemporaryDirectory();
                    //   String outputPath = '${dir.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.jpg';
                    //
                    //   final file = await imageCompression(inputPath: inputPath, outputPath: outputPath, quality: q);
                    //   await file?.stat().then((value) {
                    //     compressFileSize = value.size / 1000000;
                    //   });
                    //   inputPath = outputPath;
                    //   q += 4;
                    //   if (q > 50) break;
                    // }
                  }
                });
              },
              color: Colors.blue.shade900,
              child: Icon(Icons.file_open, color: Colors.white),
            ),
            CupertinoButton(
              onPressed: () {
                OpenFilex.open("/data/user/0/com.nimap.demo/cache/compressed_1757328934833883.jpg");
              },
              color: Colors.blue.shade900,
              child: Icon(Icons.file_present, color: Colors.white),
            ),
            CupertinoButton(
              onPressed: () {
                OpenFilex.open("/data/user/0/com.nimap.demo/cache/compressed_1757329113108914.webp");
              },
              color: Colors.blue.shade900,
              child: Icon(Icons.file_present, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
