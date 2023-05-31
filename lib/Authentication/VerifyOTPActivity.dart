import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/NewScreens/DashboardActivity.dart';
import '../Screens/PaymentGateway.dart';
import '../Screens/constant/Constant.dart';

// class VerifyOTPActivity extends StatefulWidget {
//   final String phone;
//   final String ccode;
//   const VerifyOTPActivity({Key key, this.phone, this.ccode}) : super(key: key);
//
//   @override
//   State<VerifyOTPActivity> createState() => _VerifyOTPActivityState();
// }
//
// class _VerifyOTPActivityState extends State<VerifyOTPActivity> {
//
//   GlobalKey<FormState> _key = new GlobalKey();
//   bool _otpvalidate = true;
//   String otp;
//   bool _validate = false;
//
//   @override
//   void initState() {
//     sendOTP();
//     // TODO: implement initState
//     super.initState();
//   }
//
//   Future<void> sendOTP() async {
//     var body = {
//       "phone": "${widget.phone}",
//     };
//
//     var response = await http.post(Uri.parse('https://api.mapmycrop.store/auth/send_otp'),
//       headers: {
//         "Content-Type" : "application/json"
//       },
//       body: jsonEncode(body),
//     );
//     var data = jsonDecode(response.body);
//     print(data);
//     // prefs.setString('', value)
//     if(response.statusCode==200 ||response.statusCode==201 && data==true){
//       QuickAlert.show(
//           context: context,
//           type: QuickAlertType.success,
//           text: 'OTP has been sent Successfully!',
//           confirmBtnText:'Ok',
//       );
//     }else{
//       // showDialog(
//       //     context: context,
//       //     builder: (BuildContext context) {
//       //       return AlertDialog(
//       //         backgroundColor: Colors.red[100],
//       //         title: Text("Please Verify"),
//       //         content: Text(
//       //             "VERIFY|\n Please Enter Valid Credentials"),
//       //         actions: <Widget>[
//       //           IconButton(
//       //               icon: Icon(Icons.check),
//       //               onPressed: () {
//       //                 /* Navigator.pushReplacement(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                         builder: (BuildContext context) => VerifyOTPActivity(username: user)));*/
//       //                 Navigator.pop(context);
//       //               })
//       //         ],
//       //       );
//       //     });
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Oops...',
//         text: '${data['detail']}',//'Something went wrong,Please verify details!',
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Image.asset('assets/new_images/back.png')
//           ),
//           title:Text(
//             "Authentication required",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontFamily: "Inter",
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           backgroundColor: Color(0xffECB34F),
//           elevation: 0,
//         ),
//         backgroundColor: Colors.grey[100],
//         body: SingleChildScrollView(
//           child: new Form(
//             // wrap with SingleChildScrollView
//             child: formUI(),
//             key: _key,
//             //autovalidate: _validate,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget formUI() {
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children:[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 13),
//                 child: Text(
//                   "+${widget.ccode}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:0),
//                 child: Text(
//                   widget.phone,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xffe88424),
//                     fontSize: 14,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height:10,
//           ),
//           SizedBox(
//             width: 346,
//             child: Text(
//               "We’ve sent One Time Password (OTP) to the mobile number above. Please enter it to complete verification",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           SizedBox(
//             height:20,
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 10, bottom: 20, left: 35, right: 35),
//             child: TextFormField(
//               //validator: _validateEmail,
//               style: new TextStyle(color: Colors.black, fontFamily: "Inter"),
//               //autovalidateMode: AutovalidateMode.always,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: _otpvalidate ? Colors.black : Colors.red),
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: _otpvalidate ? Colors.black : Colors.red),
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 hintText: _otpvalidate ? 'Enter OTP' : 'OTP is Required',
//                 hintStyle: TextStyle(
//                     color: _otpvalidate ? Colors.grey : Colors.red,
//                     fontFamily: "Inter"),
//                 // labelText: 'Email ID / Phone Number',
//                 //floatingLabelBehavior: FloatingLabelBehavior.auto
//               ),
//               validator: (String value) {
//                 if (value.isEmpty) {
//                   setState(() {
//                     _otpvalidate = false;
//                   });
//                 } else {
//                   setState(() {
//                     _otpvalidate = true;
//                   });
//                 }
//               },
//               onChanged:(String value) {
//                 setState(() {
//                   _otpvalidate = true;
//                 });
//               },
//               onSaved: (String value) {
//                 setState((){
//                   otp = value;
//                 });
//               },
//             ),
//           ),
//           Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     _sendToServer();
//                     // Navigator.pushReplacement(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (BuildContext context) => VerifyOTPActivity()));
//                   },
//                   child: Container(
//                       width: 319,
//                       height: 57,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: const Color(0xfff7941e),
//                       ),
//                       child: const Center(
//                           child: Text(
//                             'Continue',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontFamily: "Open Sans",
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ))),
//                 ),
//               ]),
//           SizedBox(height: 20,),
//           Text(
//             "Resend OTP",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xffe88424),
//               fontSize: 15,
//               decoration: TextDecoration.underline,
//             ),
//           ).onTap((){
//           sendOTP();
//           }),
//         ],
//       );
//   }
//
//   _sendToServer() {
//     if (_key.currentState.validate()) {
//       // No any error in validation
//       _key.currentState.save();
//       print(otp);
//       if(otp.isNotEmpty && otp!=null){
//         _verifyOTP(otp);
//       }
//       // Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (BuildContext context) =>ChoosePlanScreen()));
//     } else {
//       // validation error
//       setState(() {
//         _validate = true;
//       });
//     }
//   }
//
//   DateTime currentBackPressTime;
//
//   Future<bool> onWillPop() {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       //Toast.show("Please Press again to exit", context, duration: Toast.LENGTH_LONG);
//       Fluttertoast.showToast(
//           msg: "Please Press again to exit", toastLength: Toast.LENGTH_LONG);
//
//       return Future.value(false);
//     }
//     return Future.value(true);
//   }
//
//   _verifyOTP(String otp) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var body = {
//       "phone": "${widget.phone}",
//       "code":otp.toString(),
//     };
//
//     var response = await http.post(Uri.parse('https://api.mapmycrop.store/auth/verify_otp'),
//       headers: {
//         "Content-Type" : "application/json"
//       },
//       body: jsonEncode(body),
//     );
//     var data = jsonDecode(response.body);
//     print(data);
//     // prefs.setString('', value)
//     if(response.statusCode==200 ||response.statusCode==201 ){
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.success,
//         text: 'Phone Number has been Verified Successfully!',
//         confirmBtnText:'Ok',
//           onConfirmBtnTap:(){
//             prefs.setString('api_key', data['apikey']);
//             prefs.setString('email', data['email']);
//             prefs.setString('ph', data['phone']);
//             prefs.setBool('_isLoggedIn', true);
//             Navigator.pop(context);
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) =>
//                         DashboardActivity()));
//           }
//       );
//     }else{
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Oops...',
//         text: '${data['detail']}',//'Something went wrong,Please verify details!',
//       );
//     }
//   }
// }

class OtpPage extends StatefulWidget {
  final String ccode;
  final String phone;

  const OtpPage({Key key, this.ccode, this.phone}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();

}

class _OtpPageState extends State<OtpPage> with AutomaticKeepAliveClientMixin {

  Future<void> sendOTP() async {
    var body = {
      "phone": "${widget.phone}",
    };

    var response = await http.post(Uri.parse('https://api.mapmycrop.store/auth/send_otp'),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(body),
    );
    var data = jsonDecode(response.body);
    print(data);
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
    super.build(context);
    return Scaffold(
      body: Container(
        height: height(context),
        width: width(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:[
              const Color.fromRGBO(200, 255, 221, 1),
              const Color.fromRGBO(255, 255, 255, 1)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:100,),
            OtpHeader(phone:widget.phone,ccode:widget.ccode),
            RoundedWithCustomCursor(widget.phone),
            const SizedBox(height: 44),
            Text(
              'Didn’t receive code?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color.fromRGBO(62, 116, 165, 1),
              ),
            ),
            Text(
              'Resend',
              style: GoogleFonts.poppins(
                fontSize: 16,
                decoration: TextDecoration.underline,
                color: const Color.fromRGBO(62, 116, 165, 1),
              ),
            ).onTap((){
              sendOTP();
            }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OtpHeader extends StatefulWidget {
  final String phone;
  final String ccode;
  const OtpHeader({Key key, this.phone, this.ccode}) : super(key: key);

  @override
  State<OtpHeader> createState() => _OtpHeaderState();
}

class _OtpHeaderState extends State<OtpHeader> {
  @override
  void initState() {
    sendOTP();
    // TODO: implement initState
    super.initState();
  }

  Future<void> sendOTP() async {
    var body = {
      "phone": "${widget.phone}",
    };

    var response = await http.post(Uri.parse('https://api.mapmycrop.store/auth/send_otp'),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(body),
    );
    var data = jsonDecode(response.body);
    print(data);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Verification',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Enter the code sent to the number',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color.fromRGBO(133, 153, 170, 1),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+${widget.ccode}${widget.phone}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}

class RoundedWithCustomCursor extends StatefulWidget {
  final String phone;
  const RoundedWithCustomCursor(this.phone, {Key key}) : super(key: key);

  @override
  _RoundedWithCustomCursorState createState() =>
      _RoundedWithCustomCursorState();

  @override
  String toStringShort() => 'Rounded With Cursor';
}

class _RoundedWithCustomCursorState extends State<RoundedWithCustomCursor> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 46,
      height: 46,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod:
              AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              length: 6,
              // validator: (value) {
              //   return value == '2222' ? null : 'Pin is incorrect';
              // },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
                _verifyOTP(pin);
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          TextButton(
            onPressed: () => formKey.currentState.validate(),
            child:Text('Validate').onTap((){
              //_verifyOTP()
            }),
          ),
        ],
      ),
    );
  }
  _verifyOTP(String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      "phone": "${widget.phone}",
      "code":otp.toString(),
    };

    var response = await http.post(Uri.parse('https://api.mapmycrop.store/auth/verify_otp'),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(body),
    );
    var data = jsonDecode(response.body);
    print(data);
    // prefs.setString('', value)
    if(response.statusCode==200 ||response.statusCode==201 ){
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Phone Number has been Verified Successfully!',
          confirmBtnText:'Ok',
          onConfirmBtnTap:(){
            prefs.setString('api_key', data['apikey']);
            prefs.setString('email', data['email']??'');
            prefs.setString('ph', data['phone']);
            prefs.setBool('_isLoggedIn', true);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DashboardActivity()));
          }
      );
    }else{
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: '${data['detail']}',//'Something went wrong,Please verify details!',
      );
    }
  }
}
