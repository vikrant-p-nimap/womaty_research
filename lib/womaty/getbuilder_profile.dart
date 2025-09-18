import 'package:demo/womaty/home_controller.dart';
import 'package:demo/womaty/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetbuilderProfile extends StatelessWidget {
  const GetbuilderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (state) {
        print("home: $state");
        print(state.controller);
      },
      builder: (homeController) {
        return GetBuilder<ProfileController>(
          initState: (state) {
            print("profile: $state");
          },
          builder: (profileController) {
            return Scaffold(
              body: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("HomeController: ${homeController.home}"),
                    Text("ProfileController: ${profileController.profile}"),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
