import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/NewScreens/DashboardActivity.dart';

class VerifyOtpScreen extends StatefulWidget {
   final String username;
  // final String email;
  // final String username;
  const VerifyOtpScreen({Key key, this.username}) : super(key: key);
  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpVerificationBody(username:widget.username),//(size: size,phone:widget.phoneNumber,email:widget.email,username:widget.username),
    );
  }
}


class OtpVerificationBody extends StatefulWidget {
  // final Size size;
   final String username;
  // final String email;
  // final String username;
  const OtpVerificationBody({Key key, this.username}) : super(key: key);

  @override
  _OtpVerificationBodyState createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<OtpVerificationBody> {

  bool _isOtpFailed = false;
  // Razorpay razorpay;
  String paymentId;
  String otp,uid,user,email,phone,usercred;

  @override
  void initState() {
    // razorpay = new Razorpay();
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // razorpay.clear();
  }

  // Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   Fluttertoast.showToast(
  //       msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  //   paymentId = response.paymentId;
  //   var data;
  //   var uri = Uri.parse(
  //       "https://app.mapmycrop.com/handler/payment_paymentId.php"); //
  //   var request = new http.MultipartRequest("POST", uri);
  //   request.fields['payment_id'] = paymentId;
  //   request.fields['amt'] = "200";
  //   request.fields['name'] =user;
  //   request.fields['mail_id'] =email;
  //   print(request);
  //   var respo = await request.send();
  //
  //   if (respo.statusCode == 200) {
  //     respo.stream.transform(utf8.decoder).listen((value) async {
  //       data = jsonDecode(value);
  //       print(data);
  //       setState(() {
  //
  //       });
  //     });
  //   }
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Fluttertoast.showToast(
  //       msg: "ERROR: " + response.code.toString() + " - " + response.message,
  //       toastLength: Toast.LENGTH_SHORT);
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Fluttertoast.showToast(
  //       msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      children: [
        SizedBox(
          height:size.height * 0.05,
        ),
        Stack(
          children: [
            Container(
              height:size.height * 0.50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 5.0),
                  ),
                ],
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2.0,
                margin: EdgeInsets.all(12.0),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      padding: EdgeInsets.all(20.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Verification\n\n",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0278AE),
                              ),
                            ),
                            TextSpan(
                              text: "Enter the OTP send to your \n",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF373A40),
                              ),
                            ),
                            TextSpan(
                              text:widget.username,
                              style: TextStyle(
                                fontSize:18.0,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF373A40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: PinEntryTextField(
                        showFieldAsBox: true,
                        fields: 6,
                        onSubmit: (String pin){
                          otp = pin;
                        }
                      ),
                    ),
                    Container(
                        alignment:Alignment.bottomRight,
                        margin:EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: (){
                            _resendOTP();
                            },
                            child: Text('Resend OTP',style: TextStyle(color:Colors.blue),
                            )
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Button(
              size: size,
              text: "Continue",
              press: () {
                matchOtp();
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> matchOtp() async {
    print(phone);
    print(otp);
    var data;
    if (otp != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userID= prefs.getString('userID');
      print(userID);
      var uri = Uri.parse(
          "https://app.mapmycrop.com/handler/otp_manager.php");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['user_id'] =userID;
      request.fields['otp'] = otp;

      var response = await request.send();
      if (response.statusCode == 200) print('Uploaded!');
      response.stream.transform(utf8.decoder).transform(json.decoder).listen(
              (value) async {
            data = value;
            print(data);
            if (data['DATA'] == 'SUCCESS') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 40,
                      backgroundColor: Colors.teal[200],
                      title: Text("Successfully"),
                      content: Text("Otp matched successfully."),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              _showpayDialog();
                            })
                      ],
                    );
                  });
            }
            else {
              setState(() {
                _isOtpFailed = true;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.red[100],
                      title: Text("Failed"),
                      content: Text("Otp did Not Match."),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  });
            }
          });
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[100],
              title: Text("Invalid Credentials"),
              content: Text("Enter the OTP"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    }
  }

  void _showpayDialog() {
    showDialog(
      //barrierColor:Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //this right here
            child: Container(
              height: 370,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You will be charged 200 upon Sign up!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Card(
                        //elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              Text("1.Everything in free",textAlign:TextAlign.left,),
                              Text("2.Crop Insights"),
                              Text("3.Weather Insights"),
                              Text("4.Scouting"),
                              Text("5.API"),
                              Center(
                                child: MaterialButton(
                                  onPressed: () async {
                                    // openCheckout();
                                  },
                                  child: Text(
                                    "Pay Now",
                                    style:
                                    TextStyle(color: Colors.white),
                                  ),
                                  color: const Color(0xFF1BC0C5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Card(
                        //elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              Text("1.NDVI"),
                              Text("2.EVI"),
                              Text("3.Farm Score"),
                              Text("4.Live Weather Forecast"),
                              Text("5.Crop Classification"),
                              Center(
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => DashboardActivity()));
                                    // Navigator.pop(context);
                                    // Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Free",
                                    style:
                                    TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // void openCheckout() async {
  //   var options = {
  //     'key': 'rzp_live_18M5A9NfnnHrog',
  //     'amount':200*100,
  //     'name': 'MMC',
  //     'description': 'Subscription',
  //     'prefill': {
  //       'contact':phone,
  //       'email':email
  //     },
  //     'external': {
  //       'wallets' : ['paytm'],
  //     }
  //   };
  //   try{
  //     razorpay.open(options);
  //   }
  //   catch(e) {
  //     debugPrint(e);
  //   }
  // }

  _resendOTP() async {

    var data,datavalue;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID= prefs.getString('userID');
    print(userID);
    var uri = Uri.parse(
        "https://app.mapmycrop.com/handler/user_manager.php");
    var request = new http.MultipartRequest("POST", uri);
    print(request);
    request.fields['type'] = 'RESEND';
    request.fields['user_id'] = userID;
    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    response.stream.transform(utf8.decoder).listen((value) async {
      data = jsonDecode(value);
      print(data);
      //print(data['DATA']);
      if (data['DATA'] == 'SUCCESS') {
        // FirebaseAnalytics.instance.logEvent(
        //   name: "OTP_Success",
        //   parameters: {
        //     "content_type": "OTP_Match",
        //     "userID": userID,
        //   },
        // );
        Fluttertoast.showToast(
            msg: "OTP send Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 11.0
        );
      }
      else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red[100],
                title: Text("Invalid Credentials"),
                content: Text(data['DATA']),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    });
  }
}

class Button extends StatelessWidget {
  const Button({
    Key key,
    @required this.size,
    this.text,
    this.press,
  }) : super(key: key);

  final Size size;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.44),
        child: SizedBox(
          width: size.width * 0.5,
          height: 50.0,
          child: MaterialButton(
            elevation: 10.0,
            color: Color(0xFF4A90E2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: BorderSide(color: Color(0xFF4A90E2)),
            ),
            onPressed: press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ),
                ),
                Card(
                  color: Color(0xCDA3C5EC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  child: SizedBox(
                    width: 35.0,
                    height: 35.0,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
