
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({super.key, this.onTap});

  final VoidCallbackAction? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallbackAction?>.has('onTap', onTap));
  }

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  int currentIndex = 0;

  double? getPosition(int index, {bool isText = false}) {
    // Return Position of the element
    if (index == 0) {
      if (currentIndex == 0) {
        return 5;
      } else if (currentIndex == 1) {
        return 37;
      } else if (currentIndex == 2) {
        return isText ? 25 : 23;
      }
    } else if (index == 1) {
      if (currentIndex == 0) {
        return isText ? 25 : 23;
      } else if (currentIndex == 1) {
        return 5;
      } else if (currentIndex == 2) {
        return 37;
      }
    } else if (index == 2) {
      if (currentIndex == 0) {
        return 37;
      } else if (currentIndex == 1) {
        return isText ? 25 : 23;
      } else if (currentIndex == 2) {
        return 5;
      }
    }
    return null;
  }

  List<double> getSizes(int index) {
    // Return First Element is width and Second is Height
    if (index == 0) {
      if (currentIndex == 0) {
        return [150, 20];
      } else if (currentIndex == 1) {
        return [150, 10];
      } else if (currentIndex == 2) {
        return [150, 10];
      }
    } else if (index == 1) {
      if (currentIndex == 0) {
        return [150, 10];
      } else if (currentIndex == 1) {
        return [150, 20];
      } else if (currentIndex == 2) {
        return [150, 10];
      }
    } else if (index == 2) {
      if (currentIndex == 0) {
        return [150, 10];
      } else if (currentIndex == 1) {
        return [150, 10];
      } else if (currentIndex == 2) {
        return [150, 20];
      }
    }
    return [0, 0];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          currentIndex = currentIndex == 2 ? 0 : currentIndex + 1;
          setState(() {});
          // widget.onTap?.call();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 75,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 750),
                    top: getPosition(0, isText: true),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 750),
                      alignment: Alignment.center,
                      width: getSizes(0)[0],
                      height: getSizes(0)[1],
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Large"),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 750),
                    top: getPosition(1, isText: true),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 750),
                      alignment: Alignment.center,
                      width: getSizes(1)[0],
                      height: getSizes(1)[1],
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Medium"),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 750),
                    top: getPosition(2, isText: true),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 750),
                      alignment: Alignment.center,
                      width: getSizes(2)[0],
                      height: getSizes(2)[1],
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Small"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: 20,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 750),
                      top: getPosition(0),
                      curve: Curves.easeInOut,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 750),
                        width: currentIndex == 0 ? 15 : 10,
                        height: currentIndex == 0 ? 15 : 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 750),
                      top: getPosition(1),
                      curve: Curves.easeInOut,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 750),
                        width: currentIndex == 1 ? 15 : 10,
                        height: currentIndex == 1 ? 15 : 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 750),
                      top: getPosition(2),
                      curve: Curves.easeInOut,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 750),
                        width: currentIndex == 2 ? 15 : 10,
                        height: currentIndex == 2 ? 15 : 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
