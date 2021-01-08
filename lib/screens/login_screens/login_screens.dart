import 'package:flutter/material.dart';
import 'package:kopralapp/screens/login_screen/login_screen_view.dart';

class LoginScreen extends StatefulWidget {
  final String userStr;

  LoginScreen({this.userStr});
  @override
  LoginScreenView createState() => new LoginScreenView();
}

