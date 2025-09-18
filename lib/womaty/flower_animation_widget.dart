import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({super.key});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  double percentage = 0;
  final GlobalKey flowerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlowerAnimationWidget(
              key: flowerKey,
              percentage: percentage,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final flowerContext = flowerKey.currentContext;
            if (flowerContext != null) {
              final size = MediaQuery.of(flowerContext).size;
              setState(() {
                percentage += (size.width * 0.5) - 35;
              });
            }
          },
        ),
      ),
    );
  }
}

class FlowerAnimationWidget extends StatelessWidget {
  const FlowerAnimationWidget({super.key, required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: 82,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 15,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: percentage + 15,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.green.shade800],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.bottomCenter,
            ),
          ),
          AnimatedPositioned(
            left: percentage - 15,
            duration: Duration(milliseconds: 500),
            child: Lottie.asset(
              "assets/flower.json",
              width: 90,
              height: 90,
              repeat: true,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
