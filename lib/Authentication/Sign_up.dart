import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mmc_master/Authentication/LoginPageActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/constant/Constant.dart';

class Signup extends StatefulWidget {

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _acceptTerms = false;
  Color c = const Color.fromARGB(255, 11, 175, 40);
  String username, pwd,Email,Phone,ccode;
  final phoneController = TextEditingController();
  final pwdController = TextEditingController();
  String success;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: Color(0xffECB34F),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: new Form(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(height: height(context)*0.20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
             Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 8.0, bottom:8.0),
                      child: TextFormField(
                        validator: _validateName,
                        style: new TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            // hintText: 'Enter your product title',
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Name', floatingLabelBehavior: FloatingLabelBehavior.auto),
                        onSaved: (String value) {
                          username = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height:8.0,
                    ),
                    TextFormField(
                      validator: _validateEmail,
                      style: new TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          // hintText: 'Enter your product title',
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Email ID', floatingLabelBehavior: FloatingLabelBehavior.auto),
                      onSaved: (String value) {
                        Email = value;
                      },
                    ),
                    SizedBox(
                      height:8.0,
                    ),
                    IntlPhoneField(
                      validator: _validatePhone,
                      style: new TextStyle(color: Colors.black),
                      keyboardType: TextInputType.phone,
                      initialCountryCode:"IN",
                      countryCodeTextColor: Colors.white,
                      showDropdownIcon: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          // hintText: 'Enter your product title',
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Phone Number', floatingLabelBehavior: FloatingLabelBehavior.auto),
                      onChanged: (phone) {
                        setState(() {
                          Phone = phone.number;
                          ccode=phone.countryCode.substring(1);
                        });
                        //print(phone.number);
                      },
                      onCountryChanged: (phone) {
                        setState(() {
                          ccode=phone.countryCode.substring(1);
                          print('Country code changed to: ' + phone.countryCode.substring(1));
                        });
                      },
                    ),
                    SizedBox(
                      height:8.0,
                    ),
                    TextFormField(
                      validator: _validatePasswd,
                      keyboardType: TextInputType.visiblePassword,
                      style: new TextStyle(color: Colors.black),
                      //obscureText: true,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          // hintText: 'Enter your product description',
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Password',
                          suffixIcon: new GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child:
                            new Icon(_obscureText ? Icons.visibility : Icons.visibility_off,color: Colors.white,),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                      onSaved: (String val) {
                        pwd = val;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height:8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          //side: BorderSide(color: Colors.white)
                      ),
                      padding: EdgeInsets.only(left: 50, right: 50),
                        color: Color(0xfff7941e),
                      textColor: Colors.white,
                      child: Text('Sign Up'),
                      onPressed: () {
                        _sendToServer();
                      }
                    ),
                    MaterialButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          //side: BorderSide(color: Colors.white)
                      ),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      color:Color(0xfff7941e),
                      textColor: Colors.white,
                      child: Text('Login'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length != 0) {
      if (!regExp.hasMatch(value)) {
        return "Invalid Email";//Invalid Email
      }
      else {
        return null;
      }
    }
    else {
      return null;
    }
  }

  String _validateName(String value) {
    if (value.length == 0) {
      return "Field is Required";
    } else {
      return null;
    }
  }

  String _validatePasswd(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is Required";
      // } else if (!regExp.hasMatch(value)) {
      //   return "Invalid Password";
    } else {
      return null;
    }
  }

  String _validatePhone(String value) {
    String pattern =
        r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Number is Required";
      // } else if (!regExp.hasMatch(value)) {
      //   return "Invalid Password";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      _datareciver(username, pwd,Email,Phone,ccode);
      //fetchVillageDetails();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _datareciver(String username, String pwd,String email,String phone, String ccode) async {
    print(username);
    print(pwd);
    print(email);
    print(phone);
    print(ccode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data,datavalue;
    var body = {
        "email": "$email",
        "ph": "$phone",
        "country_code": "$ccode",
        "company_id": 1,
        "password": "$pwd"
        };
    var response1 = await
    http.post(Uri.parse('https://api.mapmycrop.store/auth/register'),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(body),

    );
    print(response1.statusCode);
    print(response1.body);
    data = jsonDecode(response1.body);
    prefs.setString('api_key', data['apikey']);
    prefs.setString('email', data['email']);
    prefs.setString('ph', data['ph']);
    // prefs.setString('', value)
    if(response1.statusCode==200){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPageActivity()));
    }else{
      print('enter valid details');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[100],
              title: Text("Please Verify"),
              content: Text(
                  "VERIFY|Email ID or Mobile Number already exists. Please verify your account to proceed."),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      /* Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => VerifyOTPActivity(username: user)));*/
                      Navigator.pop(context);
                    })
              ],
            );
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
      Fluttertoast.showToast(msg: "Please Press again to exit", toastLength: Toast.LENGTH_LONG);

      return Future.value(false);
    }
    return Future.value(true);
  }

}