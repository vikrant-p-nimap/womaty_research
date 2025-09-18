// import 'dart:io';
//
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:video_compress/video_compress.dart';
//
// class FfmegVideoCompression extends StatefulWidget {
//   const FfmegVideoCompression({super.key});
//
//   @override
//   State<FfmegVideoCompression> createState() => _FfmegVideoCompressionState();
// }
//
// class _FfmegVideoCompressionState extends State<FfmegVideoCompression> {
//   String? original;
//   String? lowQualityVideo;
//   String? mediumQualityVideo;
//   String? highQualityVideo;
//   String? ffmegCommandOneVideo;
//   String? ffmegCommandTwoVideo;
//   double progress = 0;
//   Subscription? subscription;
//
//   Future<void> compressVideo(String inputPath) async {
//     Stopwatch stopwatch = Stopwatch();
//     stopwatch.start();
//     final dir = await getTemporaryDirectory();
//     final outputPath = "${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.mp4";
//
//     const videoBitrate = "2600k";
//     const audioBitrate = "128k";
//     // Example command: lower resolution to 720p, lower bitrate
//     // String command = '-i $inputPath -vcodec libx264 -crf 28 -preset veryfast -acodec aac -b:a 128k -y $outputPath';
//     // final command = '-i $inputPath -c:v libx264 -b:v $videoBitrate -c:a aac -b:a $audioBitrate -movflags +faststart $outputPath';
//
//     // Instagram - command
//     // A 720p H.264 MP4 @ 30fps  | Bitrate ~2.5–3 Mbps
//     String command = "-i $inputPath -vf \"scale=-2:720,fps=30\" -c:v libx264 -preset fast -profile:v main -crf 23 -c:a aac -b:a 128k -movflags +faststart $outputPath";
//
//     await FFmpegKit.execute(command).then((session) async {
//       final returnCode = await session.getReturnCode();
//       if (returnCode?.isValueSuccess() ?? false) {
//         print("✅ Compression successful: $outputPath");
//
//         final file = File(outputPath);
//
//         if (file.existsSync()) {
//           // final byte = await file.readAsBytes();
//           file.stat().then((value) {
//             print("💿 Size of compressed file: ${value.size / 1000000} MB");
//           });
//         }
//
//         ffmegCommandOneVideo = outputPath;
//         // ffmegCommandTwoVideo = outputPath;
//       } else {
//         print("❌ Compression failed");
//       }
//       stopwatch.stop();
//       print("⏱️ ${stopwatch.elapsed.inSeconds / 60} mins");
//       subscription?.unsubscribe();
//     });
//   }
//
//   Future<void> videoCompressFunc(String path, VideoQuality quality) async {
//     Stopwatch stopwatch = Stopwatch();
//     stopwatch.start();
//     MediaInfo? mediaInfo = await VideoCompress.compressVideo(
//       path,
//       quality: quality,
//     );
//     if (mediaInfo != null) {
//       print("💿 Size of file compress: ${mediaInfo.filesize! / 1000000} MB");
//       if (quality == VideoQuality.LowQuality) {
//         lowQualityVideo = mediaInfo.file!.path;
//       } else if (quality == VideoQuality.MediumQuality) {
//         mediumQualityVideo = mediaInfo.file!.path;
//       } else if (quality == VideoQuality.HighestQuality) {
//         highQualityVideo = mediaInfo.file!.path;
//       }
//     }
//     original = path;
//     subscription?.unsubscribe();
//     stopwatch.stop();
//     print("⏱️ ${stopwatch.elapsed.inSeconds / 60} mins");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: 10,
//           children: [
//             CupertinoButton(
//               onPressed: () {
//                 FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: [
//                   "mp4",  // Universal standard (H.264/AAC) – BEST CHOICE
//                   "mov",  // iOS / macOS default
//                   "mkv",  // Popular on Android, streaming, open-source
//                   "avi",  // Older but still common
//                   "webm", // Web/Chrome/YouTube
//                   "3gp",  // Legacy mobile (some old phones)
//                 ]).then((value) {
//                   if (value != null) {
//                     print("📁 Size of file path: ${value.files.first.path}");
//                     print("💿 Size of file: ${value.files.first.size / 1000000} MB");
//                     compressVideo(value.files.first.path!);
//                     // videoCompressFunc(value.files.first.path!, VideoQuality.HighestQuality);
//                     original = value.files.first.path;
//
//                     // subscription = VideoCompress.compressProgress$.subscribe((p) {
//                     //   debugPrint('progress: $p');
//                     //   setState(() {
//                     //     progress = p / 100;
//                     //   });
//                     // });
//                   }
//                 });
//               },
//               color: Colors.blue.shade800,
//               child: Icon(Icons.file_copy_rounded, color: Colors.white),
//             ),
//             CircularProgressIndicator(
//               value: progress,
//               backgroundColor: Colors.black12,
//             ),
//             CupertinoButton(
//                 onPressed: () {
//                   if (original != null) {
//                     // File(original!).open();
//                     OpenFilex.open(original!);
//                   }
//                   print(original);
//                 },
//                 color: Colors.blue.shade800,
//                 child: Text("Original", style: TextStyle(color: Colors.white))),
//             CupertinoButton(
//                 onPressed: () {
//                   if (lowQualityVideo != null) {
//                     // File(lowQualityVideo!).open();
//                     // OpenFilex.open(lowQualityVideo!);
//                   }
//                     OpenFilex.open("/data/user/0/com.nimap.demo/cache/compressed_1757330823885.mp4");
//                 },
//                 color: Colors.blue.shade800,
//                 child: Text("Low", style: TextStyle(color: Colors.white))),
//             CupertinoButton(
//                 onPressed: () {
//                   if (mediumQualityVideo != null) {
//                     // File(mediumQualityVideo!).open();
//                     OpenFilex.open(mediumQualityVideo!);
//                   }
//                 },
//                 color: Colors.blue.shade800,
//                 child: Text("Medium", style: TextStyle(color: Colors.white))),
//             CupertinoButton(
//                 onPressed: () {
//                   if (highQualityVideo != null) {
//                     // File(highQualityVideo!).open();
//                     OpenFilex.open(highQualityVideo!);
//                   }
//                 },
//                 color: Colors.blue.shade800,
//                 child: Text("High", style: TextStyle(color: Colors.white))),
//             CupertinoButton(
//                 onPressed: () {
//                   if (ffmegCommandOneVideo != null) {
//                     // File(ffmegCommandOneVideo!).open();
//                     OpenFilex.open(ffmegCommandOneVideo!);
//                   }
//                 },
//                 color: Colors.blue.shade800,
//                 child: Text("FFmeg command one", style: TextStyle(color: Colors.white))),
//             CupertinoButton(
//                 onPressed: () {
//                   if (ffmegCommandTwoVideo != null) {
//                     // File(ffmegCommandTwoVideo!).open();
//                     OpenFilex.open(ffmegCommandTwoVideo!);
//                   }
//                 },
//                 color: Colors.blue.shade800,
//                 child: Text("FFmeg command two", style: TextStyle(color: Colors.white))),
//           ],
//         ),
//       ),
//     );
//   }
// }
