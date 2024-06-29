import 'package:expensr/screens/bottom_bar.dart';
import 'package:expensr/screens/login.dart';
import 'package:expensr/screens/signup.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Login.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Login(),
      );

    case Signup.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Signup(),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen doesnt exist.'),
          ),
        ),
      );
  }
}
