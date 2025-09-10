import 'package:demo/demo.dart';
import 'package:demo/womaty/cache_image_ui.dart';
import 'package:demo/womaty/capture_camera.dart';
import 'package:demo/womaty/dot_env_usage.dart';
import 'package:demo/womaty/ffmeg_video_compression.dart';
import 'package:demo/womaty/google_map_widget.dart';
import 'package:demo/womaty/image_compression.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          CupertinoButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Demo()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Pagination", style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FfmegVideoCompression()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Video Compression", style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DotEnvUsage()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Dot Env", style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCompression()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Image Compression", style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () async {
              final file = await DefaultCacheManager().getSingleFile("https://cdn.pixabay.com/video/2017/07/23/10822-226624975_large.mp4");
              print(file);
              // final ImagePicker picker = ImagePicker();
              // final XFile? cameraVideo = await picker.pickImage(
              //   source: ImageSource.camera,
              //   maxHeight: 1080,
              //   maxWidth: 1080,
              //   imageQuality: 100,
              //   requestFullMetadata: true,
              //   preferredCameraDevice: CameraDevice.front,
              // );
              //
              // cameraVideo?.length().then(
              //   (bytes) {
              //     final sizeInMB = bytes / (1024 * 1024);
              //     print("File size: ${sizeInMB.toStringAsFixed(2)} MB");
              //   },
              // );
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CaptureCamera()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Camera", style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CacheImageUi()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Image Cache", style: TextStyle(color: Colors.white)),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapWidget()));
            },
            color: Colors.blue.shade800,
            child: Center(
              child: Text("Maps", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
