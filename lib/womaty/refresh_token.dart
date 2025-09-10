// import 'dart:async';
//
// import 'package:business_log/data/sources/local/app_storage.dart';
// import 'package:business_log/data/sources/local/app_storage_key.dart';
// import 'package:business_log/data/sources/remote/api_client.dart';
// import 'package:dio/dio.dart';
//
// class RefreshToken {
//
//   static final RefreshToken _instance = RefreshToken._();
//   static RefreshToken get instance => _instance;
//
//   RefreshToken._();
//
//   Completer<dynamic>? _completer;
//   bool isAccessTokenFetch = false;
//
//   void callRefreshToken({required DioException err, required ErrorInterceptorHandler handler}) async {
//     if (_completer != null) {
//       if (_completer!.isCompleted && isAccessTokenFetch) {
//         handler.resolve(await ApiClient.client.dio.fetch(err.requestOptions));
//       } else {
//         await _completer!.future.then((value) async {
//           isAccessTokenFetch = true;
//
//           final accessToken = value['data']['accessToken'];
//           final refreshToken = value['data']['refreshToken'];
//           AppStorage.setDataInStorage(token, accessToken);
//           AppStorage.setDataInStorage(refreshToken, refreshToken);
//           err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
//
//           handler.resolve(await ApiClient.client.dio.fetch(err.requestOptions));
//         }, onError: (err) {
//           callRefreshToken(err: err, handler: handler);
//         });
//       }
//     } else {
//       _completer = Completer();
//
//       await ApiClient.client.dio.post("/api/auth/token", data: {"token": AppStorage.getDataFromStorage(refreshToken) ?? ''}).then((value) {
//         _completer!.complete(value);
//       }, onError: (err) {
//         _completer!.completeError(err);
//       });
//     }
//   }
// }
