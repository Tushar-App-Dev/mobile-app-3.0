import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Screens/constant/Constant.dart';

class GoogleSignInScreen extends StatefulWidget {
  //static String tag = '/GoogleSignInScreen';

  @override
  GoogleSignInScreenState createState() => GoogleSignInScreenState();
}

class GoogleSignInScreenState extends State<GoogleSignInScreen> {
  var isSuccess = false;
  String name = 'UserName';
  var email = 'Email id';
  String photoUrl = '';

  void onSignInTap() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
    ]);
    await googleSignIn.signIn().then((res) async {
      await res.authentication.then((accessToken) async {
        setState(() {
          isSuccess = true;
          name = res.displayName;
          email = res.email;
          photoUrl = res.photoUrl;
        });
        print('Access Token: ${accessToken.accessToken.toString()}');
      }).catchError((error) {
        isSuccess = false;
        toast(error.toString());
        setState(() {});
        throw (error.toString());
      });
    }).catchError((error) {
      isSuccess = false;
      toast(error.toString());
      setState(() {});
      throw (error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    //changeStatusColor(appColorPrimary);
    return Scaffold(
        appBar: AppBar(),
      //appBar: appBar(context, 'Google Sign In'),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(color: Color(0xFF607d8b), shape: BoxShape.circle),
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: Image.network(photoUrl).image,
                    radius: 50,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text(name, fontSize:18.0,textColor: isSuccess ? greenColor : Color(0xFF212121)),
                      text(email, fontSize:18.0, textColor: isSuccess ? greenColor : Color(0xFF212121)),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
              onTap: () => onSignInTap(),
              child: Container(
                  width: width(context),
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.red,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        "assets/new_icons/ic_google.png",
                        width: 30,
                        color: whiteColor,
                      ),
                      Center(child: Text('Sign In with google')),
                    ],
                  )))
        ],
      ),
    );
  }
}

Widget text(
    String text, {
      var fontSize =18.0,
      Color textColor,
      var fontFamily,
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.5,
      bool textAllCaps = false,
      var isLongText = false,
      bool lineThrough = false,
    }) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor ?? Colors.white54,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

