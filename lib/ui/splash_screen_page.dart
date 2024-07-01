import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000),() async {
     await checkLogin();
    });
    return const Scaffold();
  }

  Future<void> checkLogin() async {
    if(await StorageHelper().getIsLoggedIn()){
      openScreen(dashboard,requiresAsInitial: true);
    }else{
      openScreen(onboardingPage,requiresAsInitial: true);
    }
  }
}
