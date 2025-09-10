import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoStremming extends StatefulWidget {
  const VideoStremming({super.key});

  @override
  State<VideoStremming> createState() => _VideoStremmingState();
}

class _VideoStremmingState extends State<VideoStremming> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse("uri"));
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(
      _controller,
    );
  }
}
