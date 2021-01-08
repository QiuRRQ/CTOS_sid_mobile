import 'package:flutter/material.dart';
import 'package:kopralapp/screens/login_screen/login_screen_view_model.dart';
import 'package:kopralapp/utils/string.dart';
import 'package:kopralapp/utils/widget_assets.dart';

class LoginScreenView extends LoginViewModel {
  _body() {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 400.0,
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Logo(width: 130),
                      this.widget.userStr == null ? TextFormField(
                        controller: no_memebr,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: "Nomor Member", prefixIcon: Icon(Icons.person)),
                      ) : Text(""),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      TextFormField(
                        controller: kode_akses,
                        autofocus: true,
                        obscureText: !isShow,
                        decoration: InputDecoration(
                            labelText: "Kode Akses",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                                icon: Icon(isShow
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setShow())),
                      ),
                      Padding(padding: EdgeInsets.only(top: 30.0)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: ownButton(
                            ownText("LOGIN", color: Colors.white, fontSize: 17.0),
                                () {
                                  login();
                                }),
                        //ToDO: change method di atas ke login saat api siap
                      ),

                    ],


                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _body(),
    );
  }
}
