import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/views/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(RouteScreen());
}

class RouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: SC.TEXT_APPLICATION_NAME,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: SplashScreen(),
    );
  }
}
