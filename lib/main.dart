import 'package:demo/animation_widget.dart';
import 'package:demo/womaty/home.dart';
import 'package:demo/womaty/home_controller.dart';
import 'package:demo/womaty/map_example_file.dart';
import 'package:demo/womaty/map_libre_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomMarkerPage(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print(dotenv.get('API_URL'));
    return Scaffold(
      body: Center(child: SizedBox(child: AnimationWidget())),
    );
  }
}
