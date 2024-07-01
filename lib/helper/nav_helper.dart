import 'dart:collection';
import 'package:chat_baba/main.dart';
import 'package:chat_baba/ui/chat_page.dart';
import 'package:chat_baba/ui/dashboard_page.dart';
import 'package:chat_baba/ui/onboarding_page.dart';
import 'package:chat_baba/ui/sign_in_page.dart';
import 'package:chat_baba/ui/splash_screen_page.dart';
import 'package:chat_baba/ui/users_page.dart';
import 'package:flutter/material.dart';
import 'nav_observer.dart';

const String route = "/";
const String onboardingPage = "/onboarding";
const String users = "/users";
const String chat = "/chat";
const String dashboard = "/dashboard";
const String signIn = "/signIn";

Route<Object?>? generateRoute(RouteSettings settings) {
  return getRoute(settings.name);
}

Route<Object?>? getRoute(String? name, {LinkedHashMap? args}) {
  switch (name) {
    case route:
      return MaterialPageRoute(
          builder: (context) => const SplashScreenPage(),
          settings: RouteSettings(name: name));
      case onboardingPage:
      return MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
          settings: RouteSettings(name: name));
    case dashboard:
      return MaterialPageRoute(
          builder: (context) => const DashboardPage(title: "ChatBaba"),
          settings: RouteSettings(name: name));
    case users:
      return MaterialPageRoute(
          builder: (context) => const UsersPage(),
          settings: RouteSettings(name: name));
    case chat:
      return MaterialPageRoute(
          builder: (context) => ChatPage(
                args: args ?? LinkedHashMap(),
              ),
          settings: RouteSettings(name: name));
    case signIn:
      return MaterialPageRoute(
          builder: (context) => SignInPage(),
          settings: RouteSettings(name: name));
    default:
  }
  return null;
}

openScreen(String routeName,
    {bool forceNew = false,
    bool requiresAsInitial = false,
    LinkedHashMap? args}) {
  var route = getRoute(routeName, args: args);
  var context = NavObserver.navKey.currentContext;
  if (route != null && context != null) {
    if (requiresAsInitial) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else if (forceNew || !NavObserver.instance.containsRoute(route)) {
      Navigator.push(context, route);
    } else {
      Navigator.popUntil(context, (route) {
        if (route.settings.name == routeName) {
          if (args != null) {
            (route.settings.arguments as Map)["result"] = args;
          }
          return true;
        }
        return false;
      });
    }
  }
}

back(LinkedHashMap? args) {
  if (NavObserver.navKey.currentContext != null) {
    Navigator.pop(NavObserver.navKey.currentContext!, args);
  }
}
