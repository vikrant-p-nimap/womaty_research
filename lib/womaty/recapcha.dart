// import 'package:flutter/material.dart';
//
// class Recapcha extends StatefulWidget {
//   const Recapcha({super.key});
//
//   @override
//   State<Recapcha> createState() => _RecapchaState();
// }
//
// class _RecapchaState extends State<Recapcha> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RecaptchaV2(
//         apiKey: "6LeFT8MrAAAAABgQeNJtOc0DCGr-OQ07_R-o61A5",
//         apiSecret: "6LeFT8MrAAAAANNqjjAgM7Cc4b-sb1nN15Mla1fP",
//         controller: recaptchaV2Controller,
//         onVerifiedError: (err) => print("Error: $err"),
//         onVerifiedSuccessfully: (success) {
//           if (success) {
//             setState(() => token = "Verified ✅");
//           } else {
//             setState(() => token = "Failed ❌");
//           }
//         },
//       ),
//     );
//   }
// }
