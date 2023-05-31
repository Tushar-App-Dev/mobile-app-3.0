import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mmc_master/Screens/NewScreens/DashboardActivity.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/constant/Constant.dart';
import '../constants/constants.dart';
import 'ForgtPasswordActivity.dart';
import 'RegisterActivity.dart';
import 'Sign_up.dart';

class LoginPageActivity extends StatefulWidget {
  const LoginPageActivity({Key key}) : super(key: key);

  @override
  State<LoginPageActivity> createState() => _LoginPageActivityState();
}

class _LoginPageActivityState extends State<LoginPageActivity> {
  GlobalKey<FormState> _key = new GlobalKey();
  Color c = const Color.fromARGB(255, 11, 175, 40);
  String username="", pwd="",Email="";
  final phoneController = TextEditingController();
  final pwdController = TextEditingController();
  bool _obscureText = true;
  bool _phonevalidate=true;
  int _passvalidate=1;
  //int _emaivalidate = 1;
  bool _emaivalidate=true;
  bool isLoading = false;

  bool _validate = false;
  String success;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: Colors.grey.shade100,
        child: Scaffold(
          backgroundColor: Colors.transparent,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height:height(context)*0.12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: ChangedLanguage(text:
            "LOG IN",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: ChangedLanguage(text:
              "WELCOME",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
              ),
            )),
        Container(
          padding: EdgeInsets.only(top: 25, bottom: 10, left: 30, right: 30),
          child: TextFormField(
            //validator: _validateEmail,
            //autovalidateMode:AutovalidateMode.always,
            style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emaivalidate? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emaivalidate? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _emaivalidate
                  ? 'Email ID (Optional)'
                  : 'Email is optional',
              hintStyle: TextStyle(
                  color: _emaivalidate? Colors.black : Colors.red,
                  fontFamily: "Inter"),
              // labelText: 'Email ID / Phone Number',
              //floatingLabelBehavior: FloatingLabelBehavior.auto
            ),
            // validator: (String value) {
            //   String pattern =
            //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            //   RegExp regExp = new RegExp(pattern);
            //   if (value.length == 0) {
            //     if(_phonevalidate==false){
            //       setState(() {
            //         _emaivalidate = 1;
            //       });
            //     }else{
            //       setState(() {
            //         _emaivalidate = 2;
            //       });
            //     }
            //   } else if (!regExp.hasMatch(value)) {
            //     setState(() {
            //       _emaivalidate = 3;
            //       print('Invalid Email');
            //     });
            //     return 'Invalid Email';
            //   } else {
            //     if(_phonevalidate==true){
            //       setState(() {
            //         _emaivalidate = 1;
            //       });
            //     }
            //     setState(() {
            //       _emaivalidate = 1;
            //     });
            //   }
            // },
            onChanged: (String value) {
              Email = value;
            },
          ),
        ),
        // Container(
        //   padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
        //   child: TextFormField(
        //     //validator: _validateEmail,
        //     style: new TextStyle(color: Colors.black,fontFamily: "Inter"),
        //     keyboardType: TextInputType.text,
        //     decoration: InputDecoration(
        //       filled: true,
        //       fillColor: Colors.white,
        //       focusedBorder: OutlineInputBorder(
        //           borderSide: BorderSide(color:_phonevalidate?Colors.black:Colors.red),
        //           borderRadius: BorderRadius.all(Radius.circular(10))),
        //       enabledBorder: OutlineInputBorder(
        //           borderSide: BorderSide(color:_phonevalidate?Colors.black:Colors.red),
        //           borderRadius: BorderRadius.all(Radius.circular(10))),
        //       hintText: _phonevalidate?'Phone Number':'Phone Number is Required',
        //       hintStyle: TextStyle(color: _phonevalidate?Colors.black:Colors.red,fontFamily: "Inter"),
        //       // labelText: 'Email ID / Phone Number',
        //       //floatingLabelBehavior: FloatingLabelBehavior.auto
        //     ),
        //     // validator: (String value) {
        //     //     if (value.isEmpty) {
        //     //       // if(_emaivalidate==1||_emaivalidate==3){
        //     //       //   setState(() {
        //     //       //     _phonevalidate = true;
        //     //       //   });
        //     //       // }else{
        //     //       //   setState(() {
        //     //       //     _phonevalidate = false;
        //     //       //   });
        //     //       // }
        //     //       setState(() {
        //     //         _phonevalidate = false;
        //     //       });
        //     //     }
        //     //     else {
        //     //       setState(() {
        //     //         _phonevalidate = true;
        //     //       });
        //     //     }
        //     // },
        //     onChanged: (String value) {
        //       username = value;
        //     },
        //   ),
        // ),
        Container(
          padding: EdgeInsets.only(top:10, bottom: 20, left: 30, right: 30),
          child: TextFormField(
            //validator: _validateEmail,
             //autovalidateMode:AutovalidateMode.always,
            style: new TextStyle(color: Colors.black,fontFamily: "Inter"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:_phonevalidate?Colors.black:Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:_phonevalidate?Colors.black:Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _phonevalidate?'Phone Number':'Phone Number is Required',
              hintStyle: TextStyle(color: _phonevalidate?Colors.black:Colors.red,fontFamily: "Inter"),
              // labelText: 'Email ID / Phone Number',
              //floatingLabelBehavior: FloatingLabelBehavior.auto
            ),
            // validator: (String value) {
            //   if (value.isEmpty) {
            //     setState(() {
            //       _emaivalidate=false;
            //     });
            //   }
            //   else{
            //     setState(() {
            //       _emaivalidate=true;
            //     });
            //   }
            // },
            onChanged: (String value) {
              username = value;
              setState(() {
                _phonevalidate=true;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
          child: TextFormField(
            //validator: _validatePasswd,
            //autovalidateMode:AutovalidateMode.always,
            keyboardType: TextInputType.visiblePassword,
            style: new TextStyle(color: Colors.black,fontFamily: "Inter"),
            // obscureText: false,
            obscureText: _obscureText,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _passvalidate==1?Colors.black:Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _passvalidate==1?Colors.black:Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText:_passvalidate==1?'Password':'Password is Required',
                hintStyle: TextStyle(color: _passvalidate==1?Colors.black:Colors.red,fontFamily: "Inter"),
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
            // validator: (String value) {
            //   String pattern =
            //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
            //   RegExp regExp = new RegExp(pattern);
            //   if (value.length == 0) {
            //     setState(() {
            //       _passvalidate=2;
            //     });
            //     }
            //   else {
            //     setState(() {
            //       _passvalidate=1;
            //     });
            //   }
            // },
            onChanged: (String val) {
              pwd = val;
              setState(() {
                _passvalidate=1;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 30),
          child: GestureDetector(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgtPasswordActivity()));
            },
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 10, right: 5),
              child: ChangedLanguage(text:
                "Forgot Password ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading?CircularProgressIndicator(color: Colors.white,):GestureDetector(
                onTap: (){
                  // setState(() {
                  //   isLoading = true;
                  // });
                  _sendToServer();
                },
                child: Container(
                    width: 316,
                    height: 57,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xfff7941e),
                    ),
                    child:  Center(child:Text('LOGIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w600,
                      ),)
                    )
                ),
              ),
            ]),
        SizedBox(height: 27.72),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChangedLanguage(text:'New User ?  ',textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap:(){
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) =>RegisterActivity()));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterActivity()));
                },
                child: ChangedLanguage(text:
                  "Register Here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ]),
        // SizedBox(height: 27.72),
        // Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         "or continue with ",
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 15,
        //           fontFamily: "Open Sans",
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ]),
        // SizedBox(height:18),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Container(
        //       width: width / 5.5,
        //       height: width / 5,
        //       padding: EdgeInsets.all(width / 30),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Color(0xffECB34F),
        //       ),
        //       child: Image.asset('assets/new_images/facebook logo.png'),
        //     ),
        //     SizedBox(width: 20),
        //     Container(
        //       width: width / 5.2,
        //       height: width / 5,
        //       padding: EdgeInsets.all(width / 30),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Color(0xffECB34F),
        //       ),
        //       child: Image.asset('assets/new_images/Google logo.png'),
        //     )
        //   ],
        // )
      ],
    );
  }

  String _validateEmail(String value) {
    if (value.length == 0) {
      return "Email ID / Phone Number is Required";
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
      } else if (!regExp.hasMatch(value)) {
        return "Invalid Password";
    } else {
      return null;
    }
  }

  // _sendToServer() {
  //   if (_key.currentState.validate()) {
  //     _key.currentState.save();
  //     _datareciver(username,pwd);
  //   } else {
  //     setState(() {
  //       _validate = true;
  //     });
  //   }
  // }
  _sendToServer() {
    /* if (_key.currentState.validate()) {
      _key.currentState.save();*/
    if(username.isEmpty&&Email.isEmpty){
      if(username.isEmpty){
        setState((){
          //_emaivalidate =false;
          _phonevalidate = false;
        });
      }else {
        setState((){
          _emaivalidate =false;
          //_phonevalidate = false;
        });
      }
      print('please enter email or phonenumber');
    }
    else{

    }
    if(pwd.isEmpty){
      setState((){
        _passvalidate=2;
      });
      print('please enter password');
    }else{

    }
    if((username.isNotEmpty||Email.isNotEmpty)&&pwd.isNotEmpty){
      _datareciver(username, pwd,Email);
    }
    /*} else {
      setState(() {
        _validate = true;
      });
    }*/
  }

  _datareciver(String username, String pwd, String email) async {

    // setState(() {
    //   isLoading = true;
    // });

    print(username);
    //print(email);
    print(pwd);
    var user;
    if(username.isNotEmpty){
      setState(() {
        user=username;
      });
    }else if(email.isNotEmpty){
      setState(() {
        user=email;
      });
    }else if(email.isNotEmpty && username.isNotEmpty){
      setState(() {
        user=username;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data, datavalue;
    var body = {
      "username": user,
      "password": pwd
    };

    setState(() {
      isLoading = true;
    });

    var response = await http.post(Uri.parse("https://api.mapmycrop.store/auth/login"),headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "accept": "application/json"
    },body: body);
    print(response.statusCode);
    print(response.body);
    var result = jsonDecode(response.body);
    print(result['token']);

    // Future.delayed(Duration(seconds:30), (){
    //   setState((){
    //     isLoading = false;
    //   });
    // });

    if (response.statusCode == 200||response.statusCode == 201){

      setState((){
        isLoading = false;
      });
      print('Uploaded!');
    //response.stream.transform(utf8.decoder).listen((value) async {
      //data = jsonDecode(response.body);
      data= jsonDecode(response.body);
      print(data);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: await changeLanguage('Logged-In Successfully!'),
          confirmBtnText:await changeLanguage('Ok'),
          onConfirmBtnTap:(){
            prefs.setString('token', data['token']);
            prefs.setString('token_type', data['token_type']);
            prefs.setString('api_key', data['apikey']);
            prefs.setBool('_isLoggedIn', true);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DashboardActivity()));
          }
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: await changeLanguage('Wrong username or password. Please enter the correct details'),
        onConfirmBtnTap:(){
          Navigator.pop(context);
          setState((){
            isLoading = false;
          });
        }
      );
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         backgroundColor: Colors.red[100],
      //         title: Text("Invalid Credentials"),
      //         content: Text("Please enter valid credentials"),
      //         actions: <Widget>[
      //           IconButton(
      //               icon: Icon(Icons.check),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               })
      //         ],
      //       );
      //     });
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
