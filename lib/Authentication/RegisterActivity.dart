import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/NewScreens/DashboardActivity.dart';
import '../Screens/constant/Constant.dart';
import '../constants/constants.dart';
import 'CountryCode.dart';
import 'VerifyOTPActivity.dart';

class RegisterActivity extends StatefulWidget {
  const RegisterActivity({Key key}) : super(key: key);

  @override
  State<RegisterActivity> createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _acceptTerms = false;
  Color c = const Color.fromARGB(255, 11, 175, 40);
  String username="",pwd="", Email="", Phone="", ccode;
  final phoneController = TextEditingController();
  final pwdController = TextEditingController();
  bool _obscureText = true;
  int _emaivalidate = 1;
  bool _namevalidate = true;
  int _phonevalidate = 1;
  int _passvalidate = 1;

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
    // var width = width(context);
    // var height = height(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: height(context) * 0.06,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/new_images/back.png')
          ),
        ),
        SizedBox(
          height: height(context) * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: ChangedLanguage(text:
            "CREATE AN ACCOUNT",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 27.72),
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
          padding: EdgeInsets.only(top: 30, bottom: 10, left: 30, right: 30),
          child: TextFormField(
            //validator: _validateEmail,
            style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _namevalidate ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _namevalidate ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _namevalidate ? 'Name' : 'Name is Required',
              hintStyle: TextStyle(
                  color: _namevalidate ? Colors.black : Colors.red,
                  fontFamily: "Inter"),
              // labelText: 'Email ID / Phone Number',
              //floatingLabelBehavior: FloatingLabelBehavior.auto
            ),
            validator: (String value) {
              if (value.isEmpty) {
                setState(() {
                  _namevalidate = false;
                });
              } else {
                setState(() {
                  _namevalidate = true;
                });
              }
            },
            onChanged: (String value) {
              username = value;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
          child: TextFormField(
            //validator: _validateEmail,
            style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emaivalidate == 1 ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emaivalidate == 1 ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _emaivalidate == 1
                  ? 'Email ID (Optional)'
                  : 'Email is optional',
              hintStyle: TextStyle(
                  color: _emaivalidate == 1 ? Colors.black : Colors.red,
                  fontFamily: "Inter"),
              // labelText: 'Email ID / Phone Number',
              //floatingLabelBehavior: FloatingLabelBehavior.auto
            ),
            validator: (String value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              if (value.length == 0) {
                setState(() {
                  _emaivalidate = 1;
                });
              } else if (!regExp.hasMatch(value)) {
                setState(() {
                  _emaivalidate = 3;
                  print('Invalid Email');
                });
                return 'Invalid Email';
              } else {
                setState(() {
                  _emaivalidate = 1;
                });
              }
            },
            onChanged: (String value) {
              Email = value;
            },
          ),
        ),
        // Container(
        //    margin: EdgeInsets.symmetric(horizontal: 37,),
        //     child: Text('OR',style: new TextStyle(color: Colors.white,))),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
          //padding: EdgeInsets.only(top:5, bottom: 5, left: 30, right: 30),
          //color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            //color: Colors.blueAccent,
            border: Border.all(width: 1,color: Colors.black,),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IntlPhoneField(
              //validator: _validatePhone,
              style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
              keyboardType: TextInputType.phone,
              initialCountryCode: "IN",
              countryCodeTextColor: Colors.black,
              showCountryFlag: true,
              showDropdownIcon: false,
              decoration: InputDecoration(
                //contentPadding:EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: _phonevalidate == 1 ?'Phone Number' : 'Number is Required',
                hintStyle: TextStyle(color: _phonevalidate == 1 ? Colors.black : Colors.red,
                    fontFamily: "Inter"),
                // labelText: 'Phone Number',
              ),
              onChanged: (phone) {
                setState(() {
                  Phone = phone.number;
                  ccode = phone.countryCode.substring(1);
                });
                //print(phone.number);
              },
              onCountryChanged: (phone) {
                setState(() {
                  ccode = phone.countryCode.substring(1);
                  print('Country code changed to: ' +
                      phone.countryCode.substring(1));
                });
              },
              validator: (String value) {
                String pattern =
                    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
                RegExp regExp = new RegExp(pattern);
                if (value.length == 0) {
                  setState(() {
                    _phonevalidate = 2;
                  });
                } else if (!regExp.hasMatch(value)) {
                  setState(() {
                    _phonevalidate = 3;
                    print('Invalid Number');
                  });
                  return 'Invalid Number';
                } else {
                  setState(() {
                    _phonevalidate = 1;
                  });
                }
              },
            ),
          ),
        ),
        // Container(
        //     //color: Colors.white,
        //   margin:EdgeInsets.symmetric(horizontal: 30),
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(10)),
        //     child: IntlPhoneField()
        // ),
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
        SizedBox(height: 27.72),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _sendToServer();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => OtpPage(ccode:ccode,phone:Phone)));//VerifyOTPActivity(ccode:ccode,phone:Phone)));
                },
                child: Container(
                    width: 319,
                    height: 57,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xfff7941e),
                    ),
                    child: const Center(
                        child: Text(
                      'SIGN IN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w600,
                      ),
                    ))),
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
        // SizedBox(height: 18),
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

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      if(username.isNotEmpty && pwd.isNotEmpty && Phone.isNotEmpty) {
        _datareciver(username, pwd, Email, Phone, ccode);
      }else{
        Fluttertoast.showToast(
            msg: "Please fill the required Details!", toastLength: Toast.LENGTH_LONG,gravity:ToastGravity.BOTTOM,fontSize:15);
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _datareciver(String username, String pwd,String email,String phone, String ccode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('contry code is $ccode');
    var data,datavalue;
    var body;
    if(email.isNotEmpty) {
       body = {
        "email": "$email",
        "ph": "$phone",
        "country_code": "$ccode",
         "terms": true,
        "company_id": 1,
        "password": "$pwd"
      };
    }else{
       body = {
        //"email": "$email",
        "ph": "$phone",
        "country_code": "$ccode",
         "terms": true,
        "company_id": 1,
        "password": "$pwd"
      };
    }
    print(body);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OtpPage(ccode:ccode,phone:Phone,body:body)));

    // var response1 = await
    // http.post(Uri.parse('https://api.mapmycrop.com/auth/register'),
    //   headers: {
    //     "Content-Type" : "application/json"
    //   },
    //   body: jsonEncode(body),
    // );
    // print(response1.statusCode);
    // print(response1.body);
    // data = jsonDecode(response1.body);
    // // prefs.setString('', value)
    // if(response1.statusCode==200 ||response1.statusCode==201){
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (BuildContext context) => OtpPage(ccode:ccode,phone:Phone)));
    //   // QuickAlert.show(
    //   //     context: context,
    //   //     type: QuickAlertType.success,
    //   //     text: 'Your account has been created Successfully!',
    //   //     confirmBtnText:'Ok',
    //   //     onConfirmBtnTap:(){
    //   //       // prefs.setString('api_key', data['apikey']);
    //   //       // prefs.setString('email', data['email']);
    //   //       // prefs.setString('ph', data['ph']);
    //   //       // prefs.setBool('_isLoggedIn', true);
    //   //       Navigator.pop(context);
    //   //       Navigator.pushReplacement(
    //   //           context,
    //   //           MaterialPageRoute(
    //   //               builder: (BuildContext context) => OtpPage(ccode:ccode,phone:Phone)));//const DashboardActivity()));//
    //   //     }
    //   // );
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
    //     text: await changeLanguage('${data['detail']}')//'Something went wrong,Please verify details!',
    //   );
    // }
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


const List<Map<String, dynamic>> countries = [
  {
    "name": "Afghanistan",
    "flag": "🇦🇫",
    "code": "AF",
    "dial_code": 93,
    "max_length": 9
  },
  {
    "name": "Åland Islands",
    "flag": "🇦🇽",
    "code": "AX",
    "dial_code": 358,
    "max_length": 15
  },
  {
    "name": "Albania",
    "flag": "🇦🇱",
    "code": "AL",
    "dial_code": 355,
    "max_length": 9
  },
  {
    "name": "Algeria",
    "flag": "🇩🇿",
    "code": "DZ",
    "dial_code": 213,
    "max_length": 9
  },
  {
    "name": "American Samoa",
    "flag": "🇦🇸",
    "code": "AS",
    "dial_code": 1684,
    "max_length": 7
  },
  {
    "name": "Andorra",
    "flag": "🇦🇩",
    "code": "AD",
    "dial_code": 376,
    "max_length": 9
  },
  {
    "name": "Angola",
    "flag": "🇦🇴",
    "code": "AO",
    "dial_code": 244,
    "max_length": 9
  },
  {
    "name": "Anguilla",
    "flag": "🇦🇮",
    "code": "AI",
    "dial_code": 1264,
    "max_length": 7
  },
  {
    "name": "Antarctica",
    "flag": "🇦🇶",
    "code": "AQ",
    "dial_code": 672,
    "max_length": 6
  },
  {
    "name": "Antigua and Barbuda",
    "flag": "🇦🇬",
    "code": "AG",
    "dial_code": 1268,
    "max_length": 7
  },
  {
    "name": "Argentina",
    "flag": "🇦🇷",
    "code": "AR",
    "dial_code": 54,
    "max_length": 12
  },
  {
    "name": "Armenia",
    "flag": "🇦🇲",
    "code": "AM",
    "dial_code": 374,
    "max_length": 8
  },
  {
    "name": "Aruba",
    "flag": "🇦🇼",
    "code": "AW",
    "dial_code": 297,
    "max_length": 7
  },
  {
    "name": "Australia",
    "flag": "🇦🇺",
    "code": "AU",
    "dial_code": 61,
    "max_length": 15
  },
  {
    "name": "Austria",
    "flag": "🇦🇹",
    "code": "AT",
    "dial_code": 43,
    "max_length": 13
  },
  {
    "name": "Azerbaijan",
    "flag": "🇦🇿",
    "code": "AZ",
    "dial_code": 994,
    "max_length": 9
  },
  {
    "name": "Bahamas",
    "flag": "🇧🇸",
    "code": "BS",
    "dial_code": 1242,
    "max_length": 7
  },
  {
    "name": "Bahrain",
    "flag": "🇧🇭",
    "code": "BH",
    "dial_code": 973,
    "max_length": 8
  },
  {
    "name": "Bangladesh",
    "flag": "🇧🇩",
    "code": "BD",
    "dial_code": 880,
    "max_length": 10
  },
  {
    "name": "Barbados",
    "flag": "🇧🇧",
    "code": "BB",
    "dial_code": 1246,
    "max_length": 7
  },
  {
    "name": "Belarus",
    "flag": "🇧🇾",
    "code": "BY",
    "dial_code": 375,
    "max_length": 10
  },
  {
    "name": "Belgium",
    "flag": "🇧🇪",
    "code": "BE",
    "dial_code": 32,
    "max_length": 9
  },
  {
    "name": "Belize",
    "flag": "🇧🇿",
    "code": "BZ",
    "dial_code": 501,
    "max_length": 7
  },
  {
    "name": "Benin",
    "flag": "🇧🇯",
    "code": "BJ",
    "dial_code": 229,
    "max_length": 8
  },
  {
    "name": "Bermuda",
    "flag": "🇧🇲",
    "code": "BM",
    "dial_code": 1441,
    "max_length": 7
  },
  {
    "name": "Bhutan",
    "flag": "🇧🇹",
    "code": "BT",
    "dial_code": 975,
    "max_length": 8
  },
  {
    "name": "Bolivia, Plurinational State of bolivia",
    "flag": "🇧🇴",
    "code": "BO",
    "dial_code": 591,
    "max_length": 8
  },
  {
    "name": "Bosnia and Herzegovina",
    "flag": "🇧🇦",
    "code": "BA",
    "dial_code": 387,
    "max_length": 9
  },
  {
    "name": "Botswana",
    "flag": "🇧🇼",
    "code": "BW",
    "dial_code": 267,
    "max_length": 8
  },
  {
    "name": "Bouvet Island",
    "flag": "🇧🇻",
    "code": "BV",
    "dial_code": 47,
    "max_length": 15
  },
  {
    "name": "Brazil",
    "flag": "🇧🇷",
    "code": "BR",
    "dial_code": 55,
    "max_length": 11
  },
  {
    "name": "British Indian Ocean Territory",
    "flag": "🇮🇴",
    "code": "IO",
    "dial_code": 246,
    "max_length": 7
  },
  {
    "name": "Brunei Darussalam",
    "flag": "🇧🇳",
    "code": "BN",
    "dial_code": 673,
    "max_length": 7
  },
  {
    "name": "Bulgaria",
    "flag": "🇧🇬",
    "code": "BG",
    "dial_code": 359,
    "max_length": 9
  },
  {
    "name": "Burkina Faso",
    "flag": "🇧🇫",
    "code": "BF",
    "dial_code": 226,
    "max_length": 8
  },
  {
    "name": "Burundi",
    "flag": "🇧🇮",
    "code": "BI",
    "dial_code": 257,
    "max_length": 8
  },
  {
    "name": "Cambodia",
    "flag": "🇰🇭",
    "code": "KH",
    "dial_code": 855,
    "max_length": 9
  },
  {
    "name": "Cameroon",
    "flag": "🇨🇲",
    "code": "CM",
    "dial_code": 237,
    "max_length": 8
  },
  {
    "name": "Canada",
    "flag": "🇨🇦",
    "code": "CA",
    "dial_code": 1,
    "max_length": 10
  },
  {
    "name": "Cape Verde",
    "flag": "🇨🇻",
    "code": "CV",
    "dial_code": 238,
    "max_length": 7
  },
  {
    "name": "Cayman Islands",
    "flag": "🇰🇾",
    "code": "KY",
    "dial_code": 345,
    "max_length": 7
  },
  {
    "name": "Central African Republic",
    "flag": "🇨🇫",
    "code": "CF",
    "dial_code": 236,
    "max_length": 8
  },
  {
    "name": "Chad",
    "flag": "🇹🇩",
    "code": "TD",
    "dial_code": 235,
    "max_length": 7
  },
  {
    "name": "Chile",
    "flag": "🇨🇱",
    "code": "CL",
    "dial_code": 56,
    "max_length": 9
  },
  {
    "name": "China",
    "flag": "🇨🇳",
    "code": "CN",
    "dial_code": 86,
    "max_length": 12
  },
  {
    "name": "Christmas Island",
    "flag": "🇨🇽",
    "code": "CX",
    "dial_code": 61,
    "max_length": 15
  },
  {
    "name": "Cocos (Keeling) Islands",
    "flag": "🇨🇨",
    "code": "CC",
    "dial_code": 61,
    "max_length": 15
  },
  {
    "name": "Colombia",
    "flag": "🇨🇴",
    "code": "CO",
    "dial_code": 57,
    "max_length": 10
  },
  {
    "name": "Comoros",
    "flag": "🇰🇲",
    "code": "KM",
    "dial_code": 269,
    "max_length": 7
  },
  {
    "name": "Congo",
    "flag": "🇨🇬",
    "code": "CG",
    "dial_code": 242,
    "max_length": 7
  },
  {
    "name": "Congo, The Democratic Republic of the Congo",
    "flag": "🇨🇩",
    "code": "CD",
    "dial_code": 243,
    "max_length": 9
  },
  {
    "name": "Cook Islands",
    "flag": "🇨🇰",
    "code": "CK",
    "dial_code": 682,
    "max_length": 5
  },
  {
    "name": "Costa Rica",
    "flag": "🇨🇷",
    "code": "CR",
    "dial_code": 506,
    "max_length": 8
  },
  {
    "name": "Côte d'Ivoire",
    "flag": "🇨🇮",
    "code": "CI",
    "dial_code": 225,
    "max_length": 10
  },
  {
    "name": "Croatia",
    "flag": "🇭🇷",
    "code": "HR",
    "dial_code": 385,
    "max_length": 12
  },
  {
    "name": "Cuba",
    "flag": "🇨🇺",
    "code": "CU",
    "dial_code": 53,
    "max_length": 8
  },
  {
    "name": "Cyprus",
    "flag": "🇨🇾",
    "code": "CY",
    "dial_code": 357,
    "max_length": 1
  },
  {
    "name": "Czech Republic",
    "flag": "🇨🇿",
    "code": "CZ",
    "dial_code": 420,
    "max_length": 12
  },
  {
    "name": "Denmark",
    "flag": "🇩🇰",
    "code": "DK",
    "dial_code": 45,
    "max_length": 8
  },
  {
    "name": "Djibouti",
    "flag": "🇩🇯",
    "code": "DJ",
    "dial_code": 253,
    "max_length": 6
  },
  {
    "name": "Dominica",
    "flag": "🇩🇲",
    "code": "DM",
    "dial_code": 1767,
    "max_length": 7
  },
  {
    "name": "Dominican Republic",
    "flag": "🇩🇴",
    "code": "DO",
    "dial_code": 1849,
    "max_length": 12
  },
  {
    "name": "Ecuador",
    "flag": "🇪🇨",
    "code": "EC",
    "dial_code": 593,
    "max_length": 8
  },
  {
    "name": "Egypt",
    "flag": "🇪🇬",
    "code": "EG",
    "dial_code": 20,
    "max_length": 10
  },
  {
    "name": "El Salvador",
    "flag": "🇸🇻",
    "code": "SV",
    "dial_code": 503,
    "max_length": 11
  },
  {
    "name": "Equatorial Guinea",
    "flag": "🇬🇶",
    "code": "GQ",
    "dial_code": 240,
    "max_length": 6
  },
  {
    "name": "Eritrea",
    "flag": "🇪🇷",
    "code": "ER",
    "dial_code": 291,
    "max_length": 7
  },
  {
    "name": "Estonia",
    "flag": "🇪🇪",
    "code": "EE",
    "dial_code": 372,
    "max_length": 10
  },
  {
    "name": "Ethiopia",
    "flag": "🇪🇹",
    "code": "ET",
    "dial_code": 251,
    "max_length": 9
  },
  {
    "name": "Falkland Islands (Malvinas)",
    "flag": "🇫🇰",
    "code": "FK",
    "dial_code": 500,
    "max_length": 5
  },
  {
    "name": "Faroe Islands",
    "flag": "🇫🇴",
    "code": "FO",
    "dial_code": 298,
    "max_length": 6
  },
  {
    "name": "Fiji",
    "flag": "🇫🇯",
    "code": "FJ",
    "dial_code": 679,
    "max_length": 7
  },
  {
    "name": "Finland",
    "flag": "🇫🇮",
    "code": "FI",
    "dial_code": 358,
    "max_length": 12
  },
  {
    "name": "France",
    "flag": "🇫🇷",
    "code": "FR",
    "dial_code": 33,
    "max_length": 9
  },
  {
    "name": "French Guiana",
    "flag": "🇬🇫",
    "code": "GF",
    "dial_code": 594,
    "max_length": 15
  },
  {
    "name": "French Polynesia",
    "flag": "🇵🇫",
    "code": "PF",
    "dial_code": 689,
    "max_length": 6
  },
  {
    "name": "French Southern Territories",
    "flag": "🇹🇫",
    "code": "TF",
    "dial_code": 262,
    "max_length": 15
  },
  {
    "name": "Gabon",
    "flag": "🇬🇦",
    "code": "GA",
    "dial_code": 241,
    "max_length": 7
  },
  {
    "name": "Gambia",
    "flag": "🇬🇲",
    "code": "GM",
    "dial_code": 220,
    "max_length": 7
  },
  {
    "name": "Georgia",
    "flag": "🇬🇪",
    "code": "GE",
    "dial_code": 995,
    "max_length": 8
  },
  {
    "name": "Germany",
    "flag": "🇩🇪",
    "code": "DE",
    "dial_code": 49,
    "max_length": 13
  },
  {
    "name": "Ghana",
    "flag": "🇬🇭",
    "code": "GH",
    "dial_code": 233,
    "max_length": 10
  },
  {
    "name": "Gibraltar",
    "flag": "🇬🇮",
    "code": "GI",
    "dial_code": 350,
    "max_length": 8
  },
  {
    "name": "Greece",
    "flag": "🇬🇷",
    "code": "GR",
    "dial_code": 30,
    "max_length": 10
  },
  {
    "name": "Greenland",
    "flag": "🇬🇱",
    "code": "GL",
    "dial_code": 299,
    "max_length": 6
  },
  {
    "name": "Grenada",
    "flag": "🇬🇩",
    "code": "GD",
    "dial_code": 1473,
    "max_length": 7
  },
  {
    "name": "Guadeloupe",
    "flag": "🇬🇵",
    "code": "GP",
    "dial_code": 590,
    "max_length": 15
  },
  {
    "name": "Guam",
    "flag": "🇬🇺",
    "code": "GU",
    "dial_code": 1671,
    "max_length": 7
  },
  {
    "name": "Guatemala",
    "flag": "🇬🇹",
    "code": "GT",
    "dial_code": 502,
    "max_length": 8
  },
  {
    "name": "Guernsey",
    "flag": "🇬🇬",
    "code": "GG",
    "dial_code": 44,
    "max_length": 6
  },
  {
    "name": "Guinea",
    "flag": "🇬🇳",
    "code": "GN",
    "dial_code": 224,
    "max_length": 8
  },
  {
    "name": "Guinea-Bissau",
    "flag": "🇬🇼",
    "code": "GW",
    "dial_code": 245,
    "max_length": 7
  },
  {
    "name": "Guyana",
    "flag": "🇬🇾",
    "code": "GY",
    "dial_code": 592,
    "max_length": 7
  },
  {
    "name": "Haiti",
    "flag": "🇭🇹",
    "code": "HT",
    "dial_code": 509,
    "max_length": 8
  },
  {
    "name": "Heard Island and Mcdonald Islands",
    "flag": "🇭🇲",
    "code": "HM",
    "dial_code": 672,
    "max_length": 15
  },
  {
    "name": "Holy See (Vatican City State)",
    "flag": "🇻🇦",
    "code": "VA",
    "dial_code": 379,
    "max_length": 10
  },
  {
    "name": "Honduras",
    "flag": "🇭🇳",
    "code": "HN",
    "dial_code": 504,
    "max_length": 8
  },
  {
    "name": "Hong Kong",
    "flag": "🇭🇰",
    "code": "HK",
    "dial_code": 852,
    "max_length": 9
  },
  {
    "name": "Hungary",
    "flag": "🇭🇺",
    "code": "HU",
    "dial_code": 36,
    "max_length": 9
  },
  {
    "name": "Iceland",
    "flag": "🇮🇸",
    "code": "IS",
    "dial_code": 354,
    "max_length": 9
  },
  {
    "name": "India",
    "flag": "🇮🇳",
    "code": "IN",
    "dial_code": 91,
    "max_length": 10
  },
  {
    "name": "Indonesia",
    "flag": "🇮🇩",
    "code": "ID",
    "dial_code": 62,
    "max_length": 10
  },
  {
    "name": "Iran, Islamic Republic of Persian Gulf",
    "flag": "🇮🇷",
    "code": "IR",
    "dial_code": 98,
    "max_length": 10
  },
  {
    "name": "Iraq",
    "flag": "🇮🇶",
    "code": "IQ",
    "dial_code": 964,
    "max_length": 10
  },
  {
    "name": "Ireland",
    "flag": "🇮🇪",
    "code": "IE",
    "dial_code": 353,
    "max_length": 11
  },
  {
    "name": "Isle of Man",
    "flag": "🇮🇲",
    "code": "IM",
    "dial_code": 44,
    "max_length": 6
  },
  {
    "name": "Israel",
    "flag": "🇮🇱",
    "code": "IL",
    "dial_code": 972,
    "max_length": 9
  },
  {
    "name": "Italy",
    "flag": "🇮🇹",
    "code": "IT",
    "dial_code": 39,
    "max_length": 13
  },
  {
    "name": "Jamaica",
    "flag": "🇯🇲",
    "code": "JM",
    "dial_code": 1876,
    "max_length": 7
  },
  {
    "name": "Japan",
    "flag": "🇯🇵",
    "code": "JP",
    "dial_code": 81,
    "max_length": 10
  },
  {
    "name": "Jersey",
    "flag": "🇯🇪",
    "code": "JE",
    "dial_code": 44,
    "max_length": 6
  },
  {
    "name": "Jordan",
    "flag": "🇯🇴",
    "code": "JO",
    "dial_code": 962,
    "max_length": 9
  },
  {
    "name": "Kazakhstan",
    "flag": "🇰🇿",
    "code": "KZ",
    "dial_code": 7,
    "max_length": 10
  },
  {
    "name": "Kenya",
    "flag": "🇰🇪",
    "code": "KE",
    "dial_code": 254,
    "max_length": 10
  },
  {
    "name": "Kiribati",
    "flag": "🇰🇮",
    "code": "KI",
    "dial_code": 686,
    "max_length": 5
  },
  {
    "name": "Korea, Democratic People's Republic of Korea",
    "flag": "🇰🇵",
    "code": "KP",
    "dial_code": 850,
    "max_length": 10
  },
  {
    "name": "Korea, Republic of South Korea",
    "flag": "🇰🇷",
    "code": "KR",
    "dial_code": 82,
    "max_length": 11
  },
  {
    "name": "Kosovo",
    "flag": "🇽🇰",
    "code": "XK",
    "dial_code": 383,
    "max_length": 8
  },
  {
    "name": "Kuwait",
    "flag": "🇰🇼",
    "code": "KW",
    "dial_code": 965,
    "max_length": 8
  },
  {
    "name": "Kyrgyzstan",
    "flag": "🇰🇬",
    "code": "KG",
    "dial_code": 996,
    "max_length": 9
  },
  {
    "name": "Laos",
    "flag": "🇱🇦",
    "code": "LA",
    "dial_code": 856,
    "max_length": 9
  },
  {
    "name": "Latvia",
    "flag": "🇱🇻",
    "code": "LV",
    "dial_code": 371,
    "max_length": 8
  },
  {
    "name": "Lebanon",
    "flag": "🇱🇧",
    "code": "LB",
    "dial_code": 961,
    "max_length": 8
  },
  {
    "name": "Lesotho",
    "flag": "🇱🇸",
    "code": "LS",
    "dial_code": 266,
    "max_length": 8
  },
  {
    "name": "Liberia",
    "flag": "🇱🇷",
    "code": "LR",
    "dial_code": 231,
    "max_length": 8
  },
  {
    "name": "Libyan Arab Jamahiriya",
    "flag": "🇱🇾",
    "code": "LY",
    "dial_code": 218,
    "max_length": 9
  },
  {
    "name": "Liechtenstein",
    "flag": "🇱🇮",
    "code": "LI",
    "dial_code": 423,
    "max_length": 9
  },
  {
    "name": "Lithuania",
    "flag": "🇱🇹",
    "code": "LT",
    "dial_code": 370,
    "max_length": 8
  },
  {
    "name": "Luxembourg",
    "flag": "🇱🇺",
    "code": "LU",
    "dial_code": 352,
    "max_length": 11
  },
  {
    "name": "Macao",
    "flag": "🇲🇴",
    "code": "MO",
    "dial_code": 853,
    "max_length": 8
  },
  {
    "name": "Macedonia",
    "flag": "🇲🇰",
    "code": "MK",
    "dial_code": 389,
    "max_length": 8
  },
  {
    "name": "Madagascar",
    "flag": "🇲🇬",
    "code": "MG",
    "dial_code": 261,
    "max_length": 10
  },
  {
    "name": "Malawi",
    "flag": "🇲🇼",
    "code": "MW",
    "dial_code": 265,
    "max_length": 8
  },
  {
    "name": "Malaysia",
    "flag": "🇲🇾",
    "code": "MY",
    "dial_code": 60,
    "max_length": 11
  },
  {
    "name": "Maldives",
    "flag": "🇲🇻",
    "code": "MV",
    "dial_code": 960,
    "max_length": 7
  },
  {
    "name": "Mali",
    "flag": "🇲🇱",
    "code": "ML",
    "dial_code": 223,
    "max_length": 8
  },
  {
    "name": "Malta",
    "flag": "🇲🇹",
    "code": "MT",
    "dial_code": 356,
    "max_length": 8
  },
  {
    "name": "Marshall Islands",
    "flag": "🇲🇭",
    "code": "MH",
    "dial_code": 692,
    "max_length": 7
  },
  {
    "name": "Martinique",
    "flag": "🇲🇶",
    "code": "MQ",
    "dial_code": 596,
    "max_length": 15
  },
  {
    "name": "Mauritania",
    "flag": "🇲🇷",
    "code": "MR",
    "dial_code": 222,
    "max_length": 8
  },
  {
    "name": "Mauritius",
    "flag": "🇲🇺",
    "code": "MU",
    "dial_code": 230,
    "max_length": 7
  },
  {
    "name": "Mayotte",
    "flag": "🇾🇹",
    "code": "YT",
    "dial_code": 262,
    "max_length": 9
  },
  {
    "name": "Mexico",
    "flag": "🇲🇽",
    "code": "MX",
    "dial_code": 52,
    "max_length": 10
  },
  {
    "name": "Micronesia, Federated States of Micronesia",
    "flag": "🇫🇲",
    "code": "FM",
    "dial_code": 691,
    "max_length": 7
  },
  {
    "name": "Moldova",
    "flag": "🇲🇩",
    "code": "MD",
    "dial_code": 373,
    "max_length": 8
  },
  {
    "name": "Monaco",
    "flag": "🇲🇨",
    "code": "MC",
    "dial_code": 377,
    "max_length": 9
  },
  {
    "name": "Mongolia",
    "flag": "🇲🇳",
    "code": "MN",
    "dial_code": 976,
    "max_length": 8
  },
  {
    "name": "Montenegro",
    "flag": "🇲🇪",
    "code": "ME",
    "dial_code": 382,
    "max_length": 12
  },
  {
    "name": "Montserrat",
    "flag": "🇲🇸",
    "code": "MS",
    "dial_code": 1664,
    "max_length": 7
  },
  {
    "name": "Morocco",
    "flag": "🇲🇦",
    "code": "MA",
    "dial_code": 212,
    "max_length": 9
  },
  {
    "name": "Mozambique",
    "flag": "🇲🇿",
    "code": "MZ",
    "dial_code": 258,
    "max_length": 9
  },
  {
    "name": "Myanmar",
    "flag": "🇲🇲",
    "code": "MM",
    "dial_code": 95,
    "max_length": 9
  },
  {
    "name": "Namibia",
    "flag": "🇳🇦",
    "code": "NA",
    "dial_code": 264,
    "max_length": 10
  },
  {
    "name": "Nauru",
    "flag": "🇳🇷",
    "code": "NR",
    "dial_code": 674,
    "max_length": 7
  },
  {
    "name": "Nepal",
    "flag": "🇳🇵",
    "code": "NP",
    "dial_code": 977,
    "max_length": 9
  },
  {
    "name": "Netherlands",
    "flag": "🇳🇱",
    "code": "NL",
    "dial_code": 31,
    "max_length": 9
  },
  {
    "name": "Netherlands Antilles",
    "flag": "",
    "code": "AN",
    "dial_code": 599,
    "max_length": 8
  },
  {
    "name": "New Caledonia",
    "flag": "🇳🇨",
    "code": "NC",
    "dial_code": 687,
    "max_length": 6
  },
  {
    "name": "New Zealand",
    "flag": "🇳🇿",
    "code": "NZ",
    "dial_code": 64,
    "max_length": 10
  },
  {
    "name": "Nicaragua",
    "flag": "🇳🇮",
    "code": "NI",
    "dial_code": 505,
    "max_length": 8
  },
  {
    "name": "Niger",
    "flag": "🇳🇪",
    "code": "NE",
    "dial_code": 227,
    "max_length": 8
  },
  {
    "name": "Nigeria",
    "flag": "🇳🇬",
    "code": "NG",
    "dial_code": 234,
    "max_length": 10
  },
  {
    "name": "Niue",
    "flag": "🇳🇺",
    "code": "NU",
    "dial_code": 683,
    "max_length": 4
  },
  {
    "name": "Norfolk Island",
    "flag": "🇳🇫",
    "code": "NF",
    "dial_code": 672,
    "max_length": 15
  },
  {
    "name": "Northern Mariana Islands",
    "flag": "🇲🇵",
    "code": "MP",
    "dial_code": 1670,
    "max_length": 7
  },
  {
    "name": "Norway",
    "flag": "🇳🇴",
    "code": "NO",
    "dial_code": 47,
    "max_length": 8
  },
  {
    "name": "Oman",
    "flag": "🇴🇲",
    "code": "OM",
    "dial_code": 968,
    "max_length": 8
  },
  {
    "name": "Pakistan",
    "flag": "🇵🇰",
    "code": "PK",
    "dial_code": 92,
    "max_length": 10
  },
  {
    "name": "Palau",
    "flag": "🇵🇼",
    "code": "PW",
    "dial_code": 680,
    "max_length": 7
  },
  {
    "name": "Palestinian Territory, Occupied",
    "flag": "🇵🇸",
    "code": "PS",
    "dial_code": 970,
    "max_length": 9
  },
  {
    "name": "Panama",
    "flag": "🇵🇦",
    "code": "PA",
    "dial_code": 507,
    "max_length": 8
  },
  {
    "name": "Papua New Guinea",
    "flag": "🇵🇬",
    "code": "PG",
    "dial_code": 675,
    "max_length": 11
  },
  {
    "name": "Paraguay",
    "flag": "🇵🇾",
    "code": "PY",
    "dial_code": 595,
    "max_length": 9
  },
  {
    "name": "Peru",
    "flag": "🇵🇪",
    "code": "PE",
    "dial_code": 51,
    "max_length": 11
  },
  {
    "name": "Philippines",
    "flag": "🇵🇭",
    "code": "PH",
    "dial_code": 63,
    "max_length": 10
  },
  {
    "name": "Pitcairn",
    "flag": "🇵🇳",
    "code": "PN",
    "dial_code": 64,
    "max_length": 10
  },
  {
    "name": "Poland",
    "flag": "🇵🇱",
    "code": "PL",
    "dial_code": 48,
    "max_length": 9
  },
  {
    "name": "Portugal",
    "flag": "🇵🇹",
    "code": "PT",
    "dial_code": 351,
    "max_length": 9
  },
  {
    "name": "Puerto Rico",
    "flag": "🇵🇷",
    "code": "PR",
    "dial_code": 1939,
    "max_length": 15
  },
  {
    "name": "Qatar",
    "flag": "🇶🇦",
    "code": "QA",
    "dial_code": 974,
    "max_length": 8
  },
  {
    "name": "Romania",
    "flag": "🇷🇴",
    "code": "RO",
    "dial_code": 40,
    "max_length": 9
  },
  {
    "name": "Russia",
    "flag": "🇷🇺",
    "code": "RU",
    "dial_code": 7,
    "max_length": 10
  },
  {
    "name": "Rwanda",
    "flag": "🇷🇼",
    "code": "RW",
    "dial_code": 250,
    "max_length": 9
  },
  {
    "name": "Reunion",
    "flag": "🇷🇪",
    "code": "RE",
    "dial_code": 262,
    "max_length": 9
  },
  {
    "name": "Saint Barthelemy",
    "flag": "🇧🇱",
    "code": "BL",
    "dial_code": 590,
    "max_length": 9
  },
  {
    "name": "Saint Helena, Ascension and Tristan Da Cunha",
    "flag": "🇸🇭",
    "code": "SH",
    "dial_code": 290,
    "max_length": 4
  },
  {
    "name": "Saint Kitts and Nevis",
    "flag": "🇰🇳",
    "code": "KN",
    "dial_code": 1869,
    "max_length": 7
  },
  {
    "name": "Saint Lucia",
    "flag": "🇱🇨",
    "code": "LC",
    "dial_code": 1758,
    "max_length": 7
  },
  {
    "name": "Saint Martin",
    "flag": "🇲🇫",
    "code": "MF",
    "dial_code": 590,
    "max_length": 9
  },
  {
    "name": "Saint Pierre and Miquelon",
    "flag": "🇵🇲",
    "code": "PM",
    "dial_code": 508,
    "max_length": 6
  },
  {
    "name": "Saint Vincent and the Grenadines",
    "flag": "🇻🇨",
    "code": "VC",
    "dial_code": 1784,
    "max_length": 7
  },
  {
    "name": "Samoa",
    "flag": "🇼🇸",
    "code": "WS",
    "dial_code": 685,
    "max_length": 7
  },
  {
    "name": "San Marino",
    "flag": "🇸🇲",
    "code": "SM",
    "dial_code": 378,
    "max_length": 10
  },
  {
    "name": "Sao Tome and Principe",
    "flag": "🇸🇹",
    "code": "ST",
    "dial_code": 239,
    "max_length": 7
  },
  {
    "name": "Saudi Arabia",
    "flag": "🇸🇦",
    "code": "SA",
    "dial_code": 966,
    "max_length": 9
  },
  {
    "name": "Senegal",
    "flag": "🇸🇳",
    "code": "SN",
    "dial_code": 221,
    "max_length": 9
  },
  {
    "name": "Serbia",
    "flag": "🇷🇸",
    "code": "RS",
    "dial_code": 381,
    "max_length": 12
  },
  {
    "name": "Seychelles",
    "flag": "🇸🇨",
    "code": "SC",
    "dial_code": 248,
    "max_length": 6
  },
  {
    "name": "Sierra Leone",
    "flag": "🇸🇱",
    "code": "SL",
    "dial_code": 232,
    "max_length": 8
  },
  {
    "name": "Singapore",
    "flag": "🇸🇬",
    "code": "SG",
    "dial_code": 65,
    "max_length": 12
  },
  {
    "name": "Slovakia",
    "flag": "🇸🇰",
    "code": "SK",
    "dial_code": 421,
    "max_length": 9
  },
  {
    "name": "Slovenia",
    "flag": "🇸🇮",
    "code": "SI",
    "dial_code": 386,
    "max_length": 8
  },
  {
    "name": "Solomon Islands",
    "flag": "🇸🇧",
    "code": "SB",
    "dial_code": 677,
    "max_length": 5
  },
  {
    "name": "Somalia",
    "flag": "🇸🇴",
    "code": "SO",
    "dial_code": 252,
    "max_length": 8
  },
  {
    "name": "South Africa",
    "flag": "🇿🇦",
    "code": "ZA",
    "dial_code": 27,
    "max_length": 9
  },
  {
    "name": "South Sudan",
    "flag": "🇸🇸",
    "code": "SS",
    "dial_code": 211,
    "max_length": 9
  },
  {
    "name": "South Georgia and the South Sandwich Islands",
    "flag": "🇬🇸",
    "code": "GS",
    "dial_code": 500,
    "max_length": 15
  },
  {
    "name": "Spain",
    "flag": "🇪🇸",
    "code": "ES",
    "dial_code": 34,
    "max_length": 9
  },
  {
    "name": "Sri Lanka",
    "flag": "🇱🇰",
    "code": "LK",
    "dial_code": 94,
    "max_length": 9
  },
  {
    "name": "Sudan",
    "flag": "🇸🇩",
    "code": "SD",
    "dial_code": 249,
    "max_length": 9
  },
  {
    "name": "Suriname",
    "flag": "🇸🇷",
    "code": "SR",
    "dial_code": 597,
    "max_length": 7
  },
  {
    "name": "Svalbard and Jan Mayen",
    "flag": "🇸🇯",
    "code": "SJ",
    "dial_code": 47,
    "max_length": 8
  },
  {
    "name": "Eswatini",
    "flag": "🇸🇿",
    "code": "SZ",
    "dial_code": 268,
    "max_length": 8
  },
  {
    "name": "Sweden",
    "flag": "🇸🇪",
    "code": "SE",
    "dial_code": 46,
    "max_length": 13
  },
  {
    "name": "Switzerland",
    "flag": "🇨🇭",
    "code": "CH",
    "dial_code": 41,
    "max_length": 12
  },
  {
    "name": "Syrian Arab Republic",
    "flag": "🇸🇾",
    "code": "SY",
    "dial_code": 963,
    "max_length": 10
  },
  {
    "name": "Taiwan",
    "flag": "🇹🇼",
    "code": "TW",
    "dial_code": 886,
    "max_length": 9
  },
  {
    "name": "Tajikistan",
    "flag": "🇹🇯",
    "code": "TJ",
    "dial_code": 992,
    "max_length": 9
  },
  {
    "name": "Tanzania, United Republic of Tanzania",
    "flag": "🇹🇿",
    "code": "TZ",
    "dial_code": 255,
    "max_length": 9
  },
  {
    "name": "Thailand",
    "flag": "🇹🇭",
    "code": "TH",
    "dial_code": 66,
    "max_length": 9
  },
  {
    "name": "Timor-Leste",
    "flag": "🇹🇱",
    "code": "TL",
    "dial_code": 670,
    "max_length": 7
  },
  {
    "name": "Togo",
    "flag": "🇹🇬",
    "code": "TG",
    "dial_code": 228,
    "max_length": 8
  },
  {
    "name": "Tokelau",
    "flag": "🇹🇰",
    "code": "TK",
    "dial_code": 690,
    "max_length": 4
  },
  {
    "name": "Tonga",
    "flag": "🇹🇴",
    "code": "TO",
    "dial_code": 676,
    "max_length": 7
  },
  {
    "name": "Trinidad and Tobago",
    "flag": "🇹🇹",
    "code": "TT",
    "dial_code": 1868,
    "max_length": 7
  },
  {
    "name": "Tunisia",
    "flag": "🇹🇳",
    "code": "TN",
    "dial_code": 216,
    "max_length": 8
  },
  {
    "name": "Turkey",
    "flag": "🇹🇷",
    "code": "TR",
    "dial_code": 90,
    "max_length": 10
  },
  {
    "name": "Turkmenistan",
    "flag": "🇹🇲",
    "code": "TM",
    "dial_code": 993,
    "max_length": 8
  },
  {
    "name": "Turks and Caicos Islands",
    "flag": "🇹🇨",
    "code": "TC",
    "dial_code": 1649,
    "max_length": 7
  },
  {
    "name": "Tuvalu",
    "flag": "🇹🇻",
    "code": "TV",
    "dial_code": 688,
    "max_length": 6
  },
  {
    "name": "Uganda",
    "flag": "🇺🇬",
    "code": "UG",
    "dial_code": 256,
    "max_length": 9
  },
  {
    "name": "Ukraine",
    "flag": "🇺🇦",
    "code": "UA",
    "dial_code": 380,
    "max_length": 9
  },
  {
    "name": "United Arab Emirates",
    "flag": "🇦🇪",
    "code": "AE",
    "dial_code": 971,
    "max_length": 9
  },
  {
    "name": "United Kingdom",
    "flag": "🇬🇧",
    "code": "GB",
    "dial_code": 44,
    "max_length": 10
  },
  {
    "name": "United States",
    "flag": "🇺🇸",
    "code": "US",
    "dial_code": 1,
    "max_length": 10
  },
  {
    "name": "Uruguay",
    "flag": "🇺🇾",
    "code": "UY",
    "dial_code": 598,
    "max_length": 11
  },
  {
    "name": "Uzbekistan",
    "flag": "🇺🇿",
    "code": "UZ",
    "dial_code": 998,
    "max_length": 9
  },
  {
    "name": "Vanuatu",
    "flag": "🇻🇺",
    "code": "VU",
    "dial_code": 678,
    "max_length": 7
  },
  {
    "name": "Venezuela, Bolivarian Republic of Venezuela",
    "flag": "🇻🇪",
    "code": "VE",
    "dial_code": 58,
    "max_length": 10
  },
  {
    "name": "Vietnam",
    "flag": "🇻🇳",
    "code": "VN",
    "dial_code": 84,
    "max_length": 11
  },
  {
    "name": "Virgin Islands, British",
    "flag": "🇻🇬",
    "code": "VG",
    "dial_code": 1284,
    "max_length": 7
  },
  {
    "name": "Virgin Islands, U.S.",
    "flag": "🇻🇮",
    "code": "VI",
    "dial_code": 1340,
    "max_length": 7
  },
  {
    "name": "Wallis and Futuna",
    "flag": "🇼🇫",
    "code": "WF",
    "dial_code": 681,
    "max_length": 6
  },
  {
    "name": "Yemen",
    "flag": "🇾🇪",
    "code": "YE",
    "dial_code": 967,
    "max_length": 9
  },
  {
    "name": "Zambia",
    "flag": "🇿🇲",
    "code": "ZM",
    "dial_code": 260,
    "max_length": 9
  },
  {
    "name": "Zimbabwe",
    "flag": "🇿🇼",
    "code": "ZW",
    "dial_code": 263,
    "max_length": 9
  }
];


class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;

  PhoneNumber({
     this.countryISOCode,
     this.countryCode,
     this.number,
  });

  String get completeNumber {
    return countryCode + number;
  }
}
