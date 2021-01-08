import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sid/screens/login_screens/login_screens.dart';
import 'package:sid/screens/splash_screens/splash_screen_screen.dart';
import 'package:sid/utils/string.dart';

abstract class SplashViewModel extends State<SplashScreen> {
  String versionName = "";


  String appName;
  String packageName;
  String version;
  String buildNumber;
  bool isUpdate = false;
  bool updateConfirmed = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    print("version number $buildNumber");



  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

      },
    );

    _firebaseMessaging.subscribeToTopic("info");
    if(Platform.isIOS){
      _firebaseMessaging.subscribeToTopic("ios");
    }else{
      _firebaseMessaging.subscribeToTopic("android");
    }

    _firebaseMessaging.subscribeToTopic("kopral");
  }

  // Add your state and logic here
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
//      this.getAllData();
    });

    super.initState();
  }


  gotoNextPage() async {
    var ref = await SharedPreferences.getInstance();
    var usrStr = ref.getString(USER) ?? "";

    if (usrStr == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => LoginScreen())));
    } else {
      Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => LoginScreen(userStr: usrStr,))));
    }
  }

}
