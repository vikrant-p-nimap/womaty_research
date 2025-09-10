// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class CaptureCamera extends StatefulWidget {
//   const CaptureCamera({super.key});
//
//   @override
//   State<CaptureCamera> createState() => _CaptureCameraState();
// }
//
// class _CaptureCameraState extends State<CaptureCamera> {
//   late CameraController controller;
//   late List<CameraDescription> _cameras;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera(); // call async method without awaiting
//   }
//
//   Future<void> _initCamera() async {
//     try {
//       _cameras = await availableCameras();
//       controller = CameraController(
//         _cameras.first,
//         ResolutionPreset.high,
//         enableAudio: true,
//         fps: 30,
//         imageFormatGroup: ImageFormatGroup.jpeg,
//         audioBitrate: 128000,
//         videoBitrate: 2000000,
//       );
//
//       await controller.initialize();
//
//       if (mounted) {
//         setState(() {});
//       }
//     } catch (e) {
//       debugPrint("❌ Camera init error: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     return CameraPreview(
//       controller,
//     );
//   }
// }
