import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kopralapp/models/auth_model/user_auth_response.dart';
import 'package:kopralapp/models/auth_model/user_auth.dart';
import 'package:kopralapp/screens/ajuan_screen/create_ajuan_screen/create_ajuan_screen.dart';

import 'package:kopralapp/screens/home_screen/pay_later/pay_later_data/pay_later_data_screen.dart';
import 'package:kopralapp/screens/koperasi_list_screen/koperasi_list_screen.dart';
import 'package:kopralapp/screens/login_screen/login_screens.dart';
import 'package:kopralapp/screens/menu_screen/menu_screen.dart';
import 'package:kopralapp/utils/myDialog.dart';
import 'package:kopralapp/utils/string.dart';
import 'package:kopralapp/utils/widget_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginViewModel extends State<LoginScreen> {
  var no_memebr = TextEditingController();
  var kode_akses = TextEditingController();
  bool match = false;
  bool isActive = false;
  var url = TextEditingController();
  bool isShow = false;
  UserAuth User;

  setShow() {
    setState(() {
      isShow = isShow ? false : true;
    });
  }

  //this is just to simply navigate on a layout im working within
  simplePath(){
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => MenuScreen()));
  }

  login() async {
    if (no_memebr.text.isEmpty ||
        no_memebr.text == null ||
        no_memebr.text == "") {
      MyDialog(context, "Error", "Nomor Member required", Status.ERROR).build(() {
        Navigator.pop(context);
      });
      return;
    }
    if (kode_akses.text.isEmpty ||
        kode_akses.text == null ||
        kode_akses.text == "") {
      MyDialog(context, "Error", "Kode Akses required", Status.ERROR).build(() {
        Navigator.pop(context);
      });
    }
    loginProcess();
  }

  loginProcess() async {
    Loading(context).show();
    String url = AUTH_BASE_URL + API_LOGIN + "?no_member="+no_memebr.text;
    print(url);
    var response = await http.get(url).catchError((error) {
      Navigator.pop(context);
      MyDialog(context, "Error!", "Couldn't get any response from $url",
          Status.ERROR)
          .build(() {
        Navigator.pop(context);
      });
      return;
    });
    if (response.body != null) {
      print(response.body);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        try{
          Map<String, dynamic> map = jsonDecode(response.body);
        }on TypeError{
          Iterable res = json.decode(response.body);
          print(res);
          UserAuthResponse userResponse = UserAuthResponse.fromJsonMap(res);
          authUser(userResponse.authUser);
        }

      }else{
        MyDialog(context, "Error", "Server Not Respond", Status.ERROR).build(() {
          Navigator.pop(context);
        });
      }
    }
  }

  saveToken(UserAuth user) async {
    var ref = await SharedPreferences.getInstance();
    //this will save member data as USER data to access on koperasi list
    //this will get rewritten when chose koperasi from koperasi list
    ref.setString(USER, jsonEncode(user));
  }

  authUser(List<UserAuth> user)async{
    await user.forEach((element) => userCHecking(element));

    print(match);
    if(!match){
      MyDialog(context, "Error", "Login Failed", Status.ERROR).build(() {
        Navigator.pop(context);
      });
    }
    //ToDO: uncomment this.
//    if(!isActive){
//      MyDialog(context, "Error", "User sudah tidak aktif", Status.ERROR).build(() {
//        Navigator.pop(context);
//      });
//    }
  }

  getNoMember()async{
    var ref = await SharedPreferences.getInstance();
    var usrStr = ref.getString(USER) ?? "";

    setState(() {
      this.User = UserAuth.fromJsonMap(jsonDecode(usrStr));
      this.no_memebr.text = User.no_member;
    });
  }

  userCHecking(UserAuth user) async{
    if (user.no_member.toUpperCase() == no_memebr.text.toUpperCase() && user.kode_akses.toUpperCase() == kode_akses.text.toUpperCase()){
      await saveToken(user);
      setState(() {
        this.match = true;
        if(user.aktif == "Y"){
          this.isActive = true;
        }else{
          this.isActive = false;
        }
      });
      if(isActive){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => KoperasiListScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if(this.widget.userStr != null){
      getNoMember();
    }
  }
}
