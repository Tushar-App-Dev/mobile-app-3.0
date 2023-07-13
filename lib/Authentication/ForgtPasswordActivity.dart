import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Screens/NewScreens/ResetPasswordActivity.dart';
import '../Screens/constant/Constant.dart';
import '../constants/constants.dart';
import 'CountryCode.dart';

class ForgtPasswordActivity extends StatefulWidget {
  const ForgtPasswordActivity({Key key}) : super(key: key);

  @override
  State<ForgtPasswordActivity> createState() => _ForgtPasswordActivityState();
}

class _ForgtPasswordActivityState extends State<ForgtPasswordActivity> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String Phone,ccode;
  int _passvalidate=1;
  bool _obscureText = true;
  int _phonevalidate = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        //backgroundColor: Color(0xffECB34F),
        // appBar: AppBar(
        //   backgroundColor: Color(0xffECB34F),
        //   elevation: 0,
        //   title: Text(
        //     "Reset Password",
        //     //textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 16,
        //       fontFamily: "Inter",
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        // appBar: AppBar(
        //   elevation: 0.0,
        //   centerTitle: false,
        //   backgroundColor: Color(0xffECB34F),
        //   title: Text(
        //     "Forgot Password",
        //     style: TextStyle(
        //       color: Colors.white,
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
        body: Container(
          height: height(context),
          width: width(context),
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
          child: SingleChildScrollView(
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
          height: height * 0.10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/new_images/back1.png',height:40,width: 40,)
          ),
        ),
        SizedBox(
          height: height * 0.04,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ChangedLanguage( text:
          "Please enter your phone number to reset your password\n",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
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
        SizedBox(
          height: height * 0.03,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              _sendToServer();
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                height:50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xfff7941e),
                ),
                child: const Center(child: ChangedLanguage( text:'Continue',
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

  _sendToServer() async{
    if (_key.currentState.validate()) {
      _key.currentState.save();
      if(Phone.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordActivity(phone:Phone,ccode:ccode)));
      }else{
        Fluttertoast.showToast(
            msg: await changeLanguage("Please fill the required Details!"), toastLength: Toast.LENGTH_LONG,gravity:ToastGravity.BOTTOM,fontSize:15);
      }
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