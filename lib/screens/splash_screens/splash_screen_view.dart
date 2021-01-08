import 'package:flutter/material.dart';
import 'package:sid/screens/splash_screens/splash_screen_view_model.dart';
import 'package:sid/utils/string.dart';

class SplashScreenView extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/splash_screen_logo.jpg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
            Text(
              versionName,
              style: TITLE_STYLE,
            ),
          ],
        ),
      ),
    );
  }
}
