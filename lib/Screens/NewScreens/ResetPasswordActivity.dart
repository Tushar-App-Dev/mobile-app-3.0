import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordActivity extends StatefulWidget {
  const ResetPasswordActivity({Key key}) : super(key: key);

  @override
  State<ResetPasswordActivity> createState() => _ResetPasswordActivityState();
}

class _ResetPasswordActivityState extends State<ResetPasswordActivity> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String pwd,cpwd;
  int _passvalidate=1;
  bool _obscureText = true;
  var uid;

  @override
  void initState() {
    fetchUserData();
    // TODO: implement initState
    super.initState();
  }
  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('userID');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: Color(0xffECB34F),
        child: Scaffold(
          backgroundColor: Color(0xffECB34F),
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            backgroundColor: Color(0xffECB34F),
            title: Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/new_images/back.png')),
          ),
          body: SingleChildScrollView(
            child: new Form(
              // wrap with SingleChildScrollView
              child: formUI(),
              key: _key,
              //autovalidate: _validate,
            ),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: height * 0.02,
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 31, right: 31),
          child: TextFormField(
            //validator: _validatePasswd,
            keyboardType: TextInputType.visiblePassword,
            style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
            // obscureText: false,
            obscureText: _obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _passvalidate == 1 ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _passvalidate == 1 ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _passvalidate == 1
                  ? 'Password'
                  : 'Password is Required',
              hintStyle: TextStyle(
                  color: _passvalidate == 1 ? Colors.black : Colors.red,
                  fontFamily: "Inter"),
            ),
            validator: (String value) {
              String pattern =
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
              RegExp regExp = new RegExp(pattern);
              if (value.length == 0) {
                setState(() {
                  _passvalidate = 2;
                });
              } else if (!regExp.hasMatch(value)) {
                setState(() {
                  _passvalidate = 3;
                  print('Invalid password');
                });
                return 'Invalid password';
              } else {
                setState(() {
                  _passvalidate = 1;
                });
              }
            },
            onSaved: (String val) {
              pwd = val;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 31, right: 31),
          child: TextFormField(
            //validator: _validatePasswd,
            keyboardType: TextInputType.visiblePassword,
            style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
            // obscureText: false,
            obscureText: _obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _passvalidate == 1 ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _passvalidate == 1 ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _passvalidate == 1
                  ? 'Confirm Password'
                  : 'Confirm Password',
              hintStyle: TextStyle(
                  color: _passvalidate == 1 ? Colors.black : Colors.red,
                  fontFamily: "Inter"),
            ),
            validator: (String value) {
              String pattern =
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
              RegExp regExp = new RegExp(pattern);
              if (value.length == 0) {
                setState(() {
                  _passvalidate = 2;
                });
              } else if (pwd!=cpwd) {
                setState(() {
                  _passvalidate = 3;
                  print('password not match');
                });
                return 'password not match';
              } else {
                setState(() {
                  _passvalidate = 1;
                });
              }
            },
            onSaved: (String val) {
              cpwd = val;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 31, right: 31),
          child: GestureDetector(
            onTap: () {
              _sendToServer();
            },
            child: Container(
                width: 325,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xfff7941e),
                ),
                child: const Center(child: Text('SUBMIT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Open Sans",
                    fontWeight: FontWeight.w600,
                  ),))),
          ),
        ),
      ],
    );
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      //_datareciver(username, pwd);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }


  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Toast.show("Please Press again to exit", context, duration: Toast.LENGTH_LONG);
      Fluttertoast.showToast(
          msg: "Please Press again to exit", toastLength: Toast.LENGTH_LONG);

      return Future.value(false);
    }
    return Future.value(true);
  }
}