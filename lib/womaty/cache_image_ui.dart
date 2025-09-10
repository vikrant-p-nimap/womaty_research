import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';

class CacheImageUi extends StatefulWidget {
  const CacheImageUi({super.key});

  @override
  State<CacheImageUi> createState() => _CacheImageUiState();
}

class _CacheImageUiState extends State<CacheImageUi> {
  File? file;

  // String url = "https://img.freepik.com/free-vector/gradient-network-connection-background_23-2148874050.jpg";
  String url = "https://cdn.pixabay.com/video/2017/07/23/10822-226624975_large.mp4";

  @override
  void initState() {
    super.initState();
    getFile();
  }

  void getFile() async {
    file = await DefaultCacheManager().getSingleFile(url);
    print("file: $file");
    // FileInfo? info = await DefaultCacheManager().getFileFromCache(url);
    // print("Info");
    // print("${info?.file}");
    // print("${info?.statusCode}");
    // print("${info?.source}");
    // print("${info?.validTill}");
    // print("${info?.originalUrl}");

    // if (info == null) {
    //   putFile();
    // }
  }

  void putFile() async {
    print("putFile");
    // await DefaultCacheManager().putFile(url, "", )
  }

  @override
  Widget build(BuildContext context) {
    print(file?.path ?? url);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: DefaultCacheManager().getSingleFile(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              // return TextButton(
              //   onPressed: () {
              //     OpenFilex.open(file!.path);
              //   },
              //   child: Text(file!.path),
              // );
              return Image.file(
                snapshot.data!,
                width: 200,
                height: 200,
              );
            }),
      ),
    );
  }
}
