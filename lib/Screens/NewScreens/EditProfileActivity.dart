import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../Authentication/CountryCode.dart';
import '../constant/Constant.dart';

class EditProfileActivity extends StatefulWidget {
  const EditProfileActivity({Key key}) : super(key: key);

  @override
  State<EditProfileActivity> createState() => _EditProfileActivityState();
}

class _EditProfileActivityState extends State<EditProfileActivity> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _acceptTerms = false;
  Color c = const Color.fromARGB(255, 11, 175, 40);
  String username, pwd, Email, Phone, ccode,api_key;
  final phoneController = TextEditingController();
  final pwdController = TextEditingController();
  bool _obscureText = true;
  int _emaivalidate = 1;
  bool _namevalidate = true;
  int _phonevalidate = 1;
  int _passvalidate = 1;
  TextEditingController emailController= TextEditingController();
  //TextEditingController phoneController= TextEditingController();
  String success;

  @override
  void initState() {
    // TODO: implement initState
    getProfileData();
    super.initState();
  }
getProfileData()async{
  var profileData;
    var response1 = await http.get(Uri.parse('https://api.mapmycrop.com/profile/?api_key=5b19f321edd44126aee30172874c5c93'));

  print("profileData response StatusCode is ${response1.statusCode}\n and Response body is ${response1.body}  "  );
  profileData = jsonDecode(response1.body);
  print("phone = ${profileData['phone']}\n email = ${profileData['email']}\n api_key = ${profileData['api_key']}");
  Email= profileData['email'];
  Phone = profileData['phone'];
  api_key = profileData['api_key'];
  
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: Colors.grey.shade100,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            backgroundColor: Color(0xffECB34F),
            title: Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.black,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: height(context) * 0.01,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:28.0),
          child: ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(28), // Image radius
              child: Image.asset('assets/icon/profile.jpg', fit: BoxFit.cover),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
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
            onSaved: (String value) {
              username = value;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 30),
          child: TextFormField(
            controller: emailController,
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
                  ? 'Email ID '
                  : 'Email ID is Required',
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
                  _emaivalidate = 2;
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
            onSaved: (String value) {
              Email = value;
            },
          ),
        ),
        Container(
          //color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: IntlPhoneField(
              //validator: _validatePhone,
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

        ),
        SizedBox(height: 20,),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: width(context)*0.35,
                height: height(context)*0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1, ),
                  color: Color(0xff103d14),
                ),
                //padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20, ),
                child:Center(
                  child: Text(
                    "Cancel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Open Sans",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: ()async{
                var body = {
                  "email":Email,
                  "ph": 'phone'
                };
                var response = await http.put(Uri.parse("https://api.mapmycrop.com/profile/?api_key=5b19f321edd44126aee30172874c5c93"),);
              },
              child: Container(
                width: width(context)*0.35,
                height: height(context)*0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xfff7941e),
                ),
                //padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20, ),
                child: Center(
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Open Sans",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ]

        )
      ],
    );
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Please Press again to exit", toastLength: Toast.LENGTH_LONG);

      return Future.value(false);
    }
    return Future.value(true);
  }
}
