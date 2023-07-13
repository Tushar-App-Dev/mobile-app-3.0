import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Authentication/LoginPageActivity.dart';
import '../../constants/constants.dart';

class ResetPasswordActivity extends StatefulWidget {
  final String phone;
  final String ccode;
  const ResetPasswordActivity({Key key, this.phone, this.ccode}) : super(key: key);

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
  bool _otpvalidate = true;
  String otp;

  @override
  void initState() {
    sendOTP();
    // TODO: implement initState
    super.initState();
  }

  Future<void> sendOTP() async {
    var body = {
      "phone": "${widget.phone}",
      "country_code": "${widget.ccode}",
    };

    var response = await http.post(Uri.parse('https://api.mapmycrop.com/auth/send_otp'),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(body),
    );
    var data = jsonDecode(response.body);
    print('data form header state is $data');
    // prefs.setString('', value)
    // if(response.statusCode==200 ||response.statusCode==201 && data==true){
    //   QuickAlert.show(
    //     context: context,
    //     type: QuickAlertType.success,
    //     text: 'OTP has been sent Successfully!',
    //     confirmBtnText:'Ok',
    //   );
    // }else{
    //   // showDialog(
    //   //     context: context,
    //   //     builder: (BuildContext context) {
    //   //       return AlertDialog(
    //   //         backgroundColor: Colors.red[100],
    //   //         title: Text("Please Verify"),
    //   //         content: Text(
    //   //             "VERIFY|\n Please Enter Valid Credentials"),
    //   //         actions: <Widget>[
    //   //           IconButton(
    //   //               icon: Icon(Icons.check),
    //   //               onPressed: () {
    //   //                 /* Navigator.pushReplacement(
    //   //                     context,
    //   //                     MaterialPageRoute(
    //   //                         builder: (BuildContext context) => VerifyOTPActivity(username: user)));*/
    //   //                 Navigator.pop(context);
    //   //               })
    //   //         ],
    //   //       );
    //   //     });
    //   QuickAlert.show(
    //     context: context,
    //     type: QuickAlertType.error,
    //     title: 'Oops...',
    //     text: '${data['detail']}',//'Something went wrong,Please verify details!',
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        //backgroundColor: Color(0xffECB34F),
        // appBar: AppBar(
        //   elevation: 0.0,
        //   centerTitle: false,
        //   backgroundColor: Color(0xffECB34F),
        //   title: Text(
        //     "Reset Password",
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 16,
        //       fontFamily: "Inter",
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   leading: InkWell(
        //       onTap: () {
        //         Navigator.pop(context);
        //       },
        //       child: Image.asset('assets/new_images/back.png')),
        // ),
        body: new Form(
          // wrap with SingleChildScrollView
          child: formUI(),
          key: _key,
          //autovalidate: _validate,
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
    return Container(
      // height: height(context),
      // width: width(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:[
            const Color.fromRGBO(200, 255, 221, 1),
            const Color.fromRGBO(200, 255, 221, 1),
            //const Color.fromRGBO(255, 255, 255, 1)
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height * 0.12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/new_images/back1.png',height:40,width: 40,)
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Center(
            child: ChangedLanguage(text:
            'Enter the code sent to the number',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${widget.phone}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color.fromRGBO(30, 60, 87, 1),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
            child: TextFormField(
              //validator: _validateEmail,
              style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _otpvalidate ? Colors.black : Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _otpvalidate ? Colors.black : Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: _otpvalidate ? 'OTP' : 'OTP is Required',
                hintStyle: TextStyle(
                    color: _otpvalidate ? Colors.black : Colors.red,
                    fontFamily: "Inter"),
                // labelText: 'Email ID / Phone Number',
                //floatingLabelBehavior: FloatingLabelBehavior.auto
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  setState(() {
                    _otpvalidate = false;
                  });
                } else {
                  setState(() {
                    _otpvalidate = true;
                  });
                }
              },
              onChanged: (String value) {
                otp = value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
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
                hintText:
                _passvalidate == 1 ? 'Password' : 'Password is Required',
                hintStyle: TextStyle(
                    color: _passvalidate == 1 ? Colors.black : Colors.red,
                    fontFamily: "Inter"),
                //labelText: 'Password',
                suffixIcon: new GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: new Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.green,
                  ),
                ),
                //floatingLabelBehavior: FloatingLabelBehavior.auto
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
                  return 'Password must contains atleast one Uppercase,\none Lowercase,Number and Special characters';
                } else {
                  setState(() {
                    _passvalidate = 1;
                  });
                }
              },
              onChanged: (String val) {
                pwd = val;
              },
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Center(
            child: GestureDetector(
              onTap: () async{
                if (_key.currentState.validate()) {
                  _key.currentState.save();
                  if(otp.isNotEmpty && pwd.isNotEmpty) {
                    _verifyOTP(otp,pwd);
                  }else{
                    Fluttertoast.showToast(
                        msg: await changeLanguage("Please fill the required Details!"), toastLength: Toast.LENGTH_LONG,gravity:ToastGravity.BOTTOM,fontSize:15);
                  }
                }else{
                  setState(() {
                    _validate = true;
                  });
                }
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xfff7941e),
                  ),
                  child:  Center(child: ChangedLanguage( text:'SUBMIT',
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
      ),
    );
  }
  _verifyOTP(String otp,String pwd) async {
    print(otp);
    print(pwd);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      "phone": "${widget.phone}",
      "country_code":"${widget.ccode}",
      "code":otp.toString(),
      "password": pwd.toString()
    };

    var response = await http.put(Uri.parse('https://api.mapmycrop.com/auth/reset_pass_otp'),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(body),
    );
    var data = jsonDecode(response.body);
    print(data);
    if(response.statusCode==200 ||response.statusCode==201 ) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Password has been reset Successfully!',
          confirmBtnText: 'Ok',
          onConfirmBtnTap: () {
            // prefs.setString('api_key', data['apikey']);
            // prefs.setString('email', data['email'] ?? '');
            // prefs.setString('ph', data['phone']);
            // prefs.setBool('_isLoggedIn', true);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                    const LoginPageActivity()));
          }
      );
    }
    else{
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: '${data['detail']}',//'Something went wrong,Please verify details!',
          confirmBtnText: 'Ok',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            //Navigator.pop(context);
          }
      );
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