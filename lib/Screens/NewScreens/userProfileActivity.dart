// import 'dart:convert';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mmc_master/Screens/EditProfilePage.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import '../../Authentication/LoginPageActivity.dart';
// import '../../generated/l10n.dart';
// import '../PaymentGateway.dart';
// import '../SettingPage.dart';
// import '../constant/Constant.dart';
// import 'EditProfileActivity.dart';
// import 'HelpScreenActivity.dart';
//
//
// class userProfileActivity extends StatefulWidget {
//   // final String user;
//   // final String usercred;
//   const userProfileActivity({Key key}) : super(key: key);
//
//   @override
//   _userProfileActivityState createState() => _userProfileActivityState();
// }
// TextEditingController _phoneNo = TextEditingController();
//
// GlobalKey prefixKey = GlobalKey();
// double prefixWidth = 0;
// String uid,email,phone,username;
// var dataValue;
//
// class _userProfileActivityState extends State<userProfileActivity> {
//   @override
//   void initState() {
//     fetchUserData();
//     super.initState();
//   }
//
//   void fetchUserData() async {
//     var data,profileData;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //setState(() {
//     var api_key = await prefs.getString('api_key');
//     uid = prefs.getString('userID');
//     var response1 = await http.get(Uri.parse('https://api.mapmycrop.store/profile/?api_key=$api_key'));
//     print("profileData response StatusCode is ${response1.statusCode}\n and Response body is ${response1.body}  "  );
//     profileData = jsonDecode(response1.body);
//     print("phone = ${profileData['phone']}\n email = ${profileData['email']}\n api_key = ${profileData['api_key']}");
//     setState((){
//       email= profileData['email'];
//       phone = profileData['phone'];
//     });
//
//     //api_key = profileData['api_key'];
//     var uri = Uri.parse(
//         "https://app.mapmycrop.com/handler/user_data.php"); //
//     var request = new http.MultipartRequest("POST", uri);
//     request.fields['user_id'] = uid;
//     request.fields['type'] = "GET";
//     //print(request);
//      }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = height(context);
//     final screenWidth = width(context);
//     return Scaffold(
//      // backgroundColor: Color(0xffECB34F),
//       appBar: AppBar(
//         elevation: 0.0,
//         centerTitle: false,
//         backgroundColor: Color(0xffECB34F),
//         title: ChangedLanguage(text:
//           "Profile",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontFamily: "Inter",
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Image.asset('assets/new_images/back.png')),
//       ),
//       body: SafeArea(
//         top: true,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:
//             EdgeInsets.only(left: 16.0, right: 16.0, top:5.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 ClipOval(
//                   child: SizedBox.fromSize(
//                     size: Size.fromRadius(28), // Image radius
//                     child:Icon(
//                       Icons.account_circle,
//                       color: Colors.yellow.shade500,
//                       size: 50,
//                     ),
//                     //Image.asset('assets/icon/profile.jpg', fit: BoxFit.cover),
//                   ),
//                 ),
//                 phone!=null?Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ChangedLanguage(text:
//                     '${phone!=null ? phone:''}',
//                     style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',),
//                   ),
//                 ):SizedBox(),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ChangedLanguage(text:
//                     email!=null?email:'',
//                     style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',),
//                   ),
//                 ),
//                 Container(
//                   width: 266,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:[
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,right: 10),
//                         child: Divider(color:Colors.grey,thickness: 2,),
//                       ),
//                       SizedBox(height: 25),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.only(right: 20, ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:[
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: 25,
//                                           height: 25,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: 25,
//                                                 height: 25,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: Icon(Icons.notifications_none,color: Colors.black,),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Expanded(
//                                           child: SizedBox(
//                                             child: ChangedLanguage(text:
//                                               "Notifications",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // SizedBox(width: 52),
//                                   // Container(
//                                   //   decoration: BoxDecoration(
//                                   //     borderRadius: BorderRadius.circular(10),
//                                   //     color: Colors.white,
//                                   //   ),
//                                   //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2, ),
//                                   //   child: Row(
//                                   //     mainAxisSize: MainAxisSize.min,
//                                   //     mainAxisAlignment: MainAxisAlignment.center,
//                                   //     crossAxisAlignment: CrossAxisAlignment.center,
//                                   //     children:[
//                                   //       ChangedLanguage(text:
//                                   //         "12",
//                                   //         style: TextStyle(
//                                   //           color: Color(0xff001a49),
//                                   //           fontSize: 14,
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: screenHeight*0.03),
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: Icon(Icons.message_outlined,color: Colors.black,),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Expanded(
//                                           child: SizedBox(
//                                             child: ChangedLanguage(text:
//                                               "Messages",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // SizedBox(width: 52),
//                                   // Container(
//                                   //   decoration: BoxDecoration(
//                                   //     borderRadius: BorderRadius.circular(10),
//                                   //     color: Colors.white,
//                                   //   ),
//                                   //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2, ),
//                                   //   child: Row(
//                                   //     mainAxisSize: MainAxisSize.min,
//                                   //     mainAxisAlignment: MainAxisAlignment.center,
//                                   //     crossAxisAlignment: CrossAxisAlignment.center,
//                                   //     children:[
//                                   //       ChangedLanguage(text:
//                                   //         "1",
//                                   //         style: TextStyle(
//                                   //           color: Color(0xff001a49),
//                                   //           fontSize: 14,
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                             //SizedBox(height: screenHeight*0.03),
//                             /*Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: Icon(Icons.attach_money_outlined,color: Colors.black,),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Expanded(
//                                           child: SizedBox(
//                                             child: ChangedLanguage(text:
//                                               "Buy Premium",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // SizedBox(width: 52),
//                                   // Container(
//                                   //   decoration: BoxDecoration(
//                                   //     borderRadius: BorderRadius.circular(10),
//                                   //     color: Colors.white,
//                                   //   ),
//                                   //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2, ),
//                                   //   child: Row(
//                                   //     mainAxisSize: MainAxisSize.min,
//                                   //     mainAxisAlignment: MainAxisAlignment.center,
//                                   //     crossAxisAlignment: CrossAxisAlignment.center,
//                                   //     children:[
//                                   //       ChangedLanguage(text:
//                                   //         "1",
//                                   //         style: TextStyle(
//                                   //           color: Color(0xff001a49),
//                                   //           fontSize: 14,
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ).onTap((){
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> ChoosePlanScreen()));
//                             }),*/
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight*0.02),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,right: 10,top: 10.0),
//                         child: Divider(color:Colors.grey,thickness: 2,),
//                       ),
//                       SizedBox(height: screenHeight*0.04),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.only(right: 20, ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:[
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: GestureDetector(
//                                                     onTap: (){
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) => HelpScreenActivity()));
//                                                     },
//                                                     child: Icon(Icons.help_outline,color: Colors.black,)),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         SizedBox(
//                                           width:80,
//                                           child: GestureDetector(
//                                             onTap: (){
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) => HelpScreenActivity()));
//                                             },
//                                             child: ChangedLanguage(text:
//                                               "Help",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: screenHeight*0.04),
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: GestureDetector(
//                                                     onTap: (){
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) => Setting()));
//                                                     },
//                                                     child: Icon(Icons.settings,color: Colors.black,)
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: (){
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) => Setting()));
//                                           },
//                                           child: SizedBox(
//                                             width: 80,
//                                             child: ChangedLanguage(text:
//                                               "Settings",
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight*0.04),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,right: 10,bottom: 10),
//                         child: Divider(color:Colors.grey,thickness: 2,),
//                       ),
//                       SizedBox(height: screenHeight*0.02),
//                       Container(
//                         width: screenWidth*0.4,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children:[
//                             Expanded(
//                               child: GestureDetector(
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children:[
//                                     Container(
//                                       width: screenWidth*0.08,
//                                       height: screenHeight*0.03,
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children:[
//                                           Container(
//                                             width: screenWidth*0.08,
//                                             height: screenHeight*0.03,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Icon(Icons.logout_outlined,color: Colors.black,),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: SizedBox(
//                                         child: ChangedLanguage(text:
//                                           "Log Out",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () async {
//                                   QuickAlert.show(
//                                       context: context,
//                                       type: QuickAlertType.confirm,
//                                       text: 'Do you want to logout',
//                                       confirmBtnText: 'Yes',
//                                       cancelBtnText: 'No',
//                                       confirmBtnColor: Colors.green,
//                                       onCancelBtnTap:(){
//                                         Navigator.pop(context);
//                                       },
//                                       onConfirmBtnTap: () async {
//                                         SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                         prefs.setBool('_isLoggedIn', false);
//                                         Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (BuildContext context) =>
//                                                 const LoginPageActivity()));
//                                       }
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../Authentication/LoginPageActivity.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../PaymentGateway.dart';
import '../SettingPage.dart';
import '../constant/Constant.dart';
import 'ContactUsActivity.dart';
import 'EditProfileActivity.dart';
import 'HelpScreenActivity.dart';
import 'PrivacyPolicyAcivity.dart';
import 'TermsAndConditionActivity.dart';

// class userProfileActivity extends StatefulWidget {
//   // final String user;
//   // final String usercred;
//   const userProfileActivity({Key key}) : super(key: key);
//
//   @override
//   _userProfileActivityState createState() => _userProfileActivityState();
// }
// TextEditingController _phoneNo = TextEditingController();
//
// GlobalKey prefixKey = GlobalKey();
// double prefixWidth = 0;
// String uid,email,phone,username;
// var dataValue;
//
// class _userProfileActivityState extends State<userProfileActivity> {
//   @override
//   void initState() {
//     fetchUserData();
//     super.initState();
//   }
//
//   void fetchUserData() async {
//     var data,profileData;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //setState(() {
//     var api_key = await prefs.getString('api_key');
//     uid = prefs.getString('userID');
//     var response1 = await http.get(Uri.parse('https://api.mapmycrop.store/profile/?api_key=$api_key'));
//     print("profileData response StatusCode is ${response1.statusCode}\n and Response body is ${response1.body}  "  );
//     profileData = jsonDecode(response1.body);
//     print("phone = ${profileData['phone']}\n email = ${profileData['email']}\n api_key = ${profileData['api_key']}");
//     setState((){
//       email= profileData['email'];
//       phone = profileData['phone'];
//     });
//
//     //api_key = profileData['api_key'];
//     var uri = Uri.parse(
//         "https://app.mapmycrop.com/handler/user_data.php"); //
//     var request = new http.MultipartRequest("POST", uri);
//     request.fields['user_id'] = uid;
//     request.fields['type'] = "GET";
//     //print(request);
//      }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = height(context);
//     final screenWidth = width(context);
//     return Scaffold(
//       backgroundColor: Color(0XFFECB34F),
//       appBar: AppBar(
//         elevation: 0.0,
//         centerTitle: false,
//         backgroundColor: Color(0xffECB34F),
//         title: ChangedLanguage(text:
//           "Profile",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontFamily: "Inter",
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Image.asset('assets/new_assets/back.png')),
//       ),
//       body: SafeArea(
//         top: true,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:
//             EdgeInsets.only(left: 16.0, right: 16.0, top:5.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 ClipOval(
//                   child: SizedBox.fromSize(
//                     size: Size.fromRadius(28), // Image radius
//                     child:Icon(
//                       Icons.account_circle,
//                       color: Colors.yellow.shade500,
//                       size: 50,
//                     ),
//                     //Image.asset('assets/icon/profile.jpg', fit: BoxFit.cover),
//                   ),
//                 ),
//                 phone!=null?Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ChangedLanguage(text:
//                     '${phone!=null ? phone:''}',
//                     style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',),
//                   ),
//                 ):SizedBox(),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ChangedLanguage(text:
//                     email!=null?email:'',
//                     style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',),
//                   ),
//                 ),
//                 Container(
//                   width: 266,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:[
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,right: 10),
//                         child: Divider(color:Colors.grey,thickness: 2,),
//                       ),
//                       SizedBox(height: 25),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.only(right: 20, ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:[
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: 25,
//                                           height: 25,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: 25,
//                                                 height: 25,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: Icon(Icons.notifications_none,color: Colors.white,),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Expanded(
//                                           child: SizedBox(
//                                             child: ChangedLanguage(text:
//                                               "Notifications",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // SizedBox(width: 52),
//                                   // Container(
//                                   //   decoration: BoxDecoration(
//                                   //     borderRadius: BorderRadius.circular(10),
//                                   //     color: Colors.white,
//                                   //   ),
//                                   //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2, ),
//                                   //   child: Row(
//                                   //     mainAxisSize: MainAxisSize.min,
//                                   //     mainAxisAlignment: MainAxisAlignment.center,
//                                   //     crossAxisAlignment: CrossAxisAlignment.center,
//                                   //     children:[
//                                   //       ChangedLanguage(text:
//                                   //         "12",
//                                   //         style: TextStyle(
//                                   //           color: Color(0xff001a49),
//                                   //           fontSize: 14,
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: screenHeight*0.03),
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: Icon(Icons.message_outlined,color: Colors.white,),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Expanded(
//                                           child: SizedBox(
//                                             child: ChangedLanguage(text:
//                                               "Messages",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // SizedBox(width: 52),
//                                   // Container(
//                                   //   decoration: BoxDecoration(
//                                   //     borderRadius: BorderRadius.circular(10),
//                                   //     color: Colors.white,
//                                   //   ),
//                                   //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2, ),
//                                   //   child: Row(
//                                   //     mainAxisSize: MainAxisSize.min,
//                                   //     mainAxisAlignment: MainAxisAlignment.center,
//                                   //     crossAxisAlignment: CrossAxisAlignment.center,
//                                   //     children:[
//                                   //       ChangedLanguage(text:
//                                   //         "1",
//                                   //         style: TextStyle(
//                                   //           color: Color(0xff001a49),
//                                   //           fontSize: 14,
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight*0.02),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,right: 10,top: 10.0),
//                         child: Divider(color:Colors.grey,thickness: 2,),
//                       ),
//                       SizedBox(height: screenHeight*0.04),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.only(right: 20, ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:[
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: GestureDetector(
//                                                     onTap: (){
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) => HelpScreenActivity()));
//                                                     },
//                                                     child: Icon(Icons.help_outline,color: Colors.white,)),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         SizedBox(
//                                           width:80,
//                                           child: GestureDetector(
//                                             onTap: (){
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) => HelpScreenActivity()));
//                                             },
//                                             child: ChangedLanguage(text:
//                                               "Help",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: screenHeight*0.04),
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children:[
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children:[
//                                         Container(
//                                           width: screenWidth*0.08,
//                                           height: screenHeight*0.03,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children:[
//                                               Container(
//                                                 width: screenWidth*0.08,
//                                                 height: screenHeight*0.03,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(8),
//                                                 ),
//                                                 child: GestureDetector(
//                                                     onTap: (){
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) => Setting()));
//                                                     },
//                                                     child: Icon(Icons.settings,color: Colors.white,)
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: (){
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) => Setting()));
//                                           },
//                                           child: SizedBox(
//                                             width: 80,
//                                             child: ChangedLanguage(text:
//                                               "Settings",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight*0.04),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,right: 10,bottom: 10),
//                         child: Divider(color:Colors.grey,thickness: 2,),
//                       ),
//                       SizedBox(height: screenHeight*0.02),
//                       Container(
//                         width: screenWidth*0.4,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children:[
//                             Expanded(
//                               child: GestureDetector(
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children:[
//                                     Container(
//                                       width: screenWidth*0.08,
//                                       height: screenHeight*0.03,
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children:[
//                                           Container(
//                                             width: screenWidth*0.08,
//                                             height: screenHeight*0.03,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Icon(Icons.logout_outlined,color: Colors.white,),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: SizedBox(
//                                         child: ChangedLanguage(text:
//                                           "Log Out",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () async {
//                                   QuickAlert.show(
//                                       context: context,
//                                       type: QuickAlertType.confirm,
//                                       text: 'Do you want to logout',
//                                       confirmBtnText: 'Yes',
//                                       cancelBtnText: 'No',
//                                       confirmBtnColor: Colors.green,
//                                       onCancelBtnTap:(){
//                                         Navigator.pop(context);
//                                       },
//                                       onConfirmBtnTap: () async {
//                                         SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                         prefs.setBool('_isLoggedIn', false);
//                                         Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (BuildContext context) =>
//                                                 const LoginPageActivity()));
//                                       }
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class userProfileActivity extends StatefulWidget {
  //static var tag = "/BankingMenu";

  @override
  _userProfileActivityState createState() => _userProfileActivityState();
}

class _userProfileActivityState extends State<userProfileActivity> {
  var email, phone;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var data, profileData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //setState(() {
    var api_key = await prefs.getString('api_key');
    var response1 = await http.get(
        Uri.parse('https://api.mapmycrop.store/profile/?api_key=$api_key'));
    print(
        "profileData response StatusCode is ${response1.statusCode}\n and Response body is ${response1.body}  ");
    profileData = jsonDecode(response1.body);
    print(
        "phone = ${profileData['phone']}\n email = ${profileData['email']}\n api_key = ${profileData['api_key']}");
    setState(() {
      email = profileData['email'];
      phone = profileData['phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFFECB34F),
        title:ChangedLanguage(text:'Profile'),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //30.height,
              //ChangedLanguage(text:'Profile', style: boldTextStyle(size: )),
              //20.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.orange),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/new_images/logo.png')), //CachedNetworkImageProvider('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
                      ),
                    ),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        7.height,
                        Text(email != null ? email : '',
                            style: boldTextStyle(size: 18)),
                        5.height,
                        Text(phone != null ? phone : '',
                            style: primaryTextStyle(color: Banking_TextColorSecondary)),
                        // 5.height,
                        // ChangedLanguage(text:Banking_lbl_app_Name, style: secondaryTextStyle()),
                      ],
                    ).expand()
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  children: <Widget>[
                    bankingOption(Banking_ic_Setting, Banking_lbl_Setting,
                        Banking_pinkLightColor).onTap((){
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => Setting()));
                    }),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Image.asset('assets/ic_theme.png', height: 24, width: 24, color: appColorPrimary).paddingOnly(left: 6),
                    //         16.width,
                    //         ChangedLanguage(text:Banking_lblDarkMode, style: primaryTextStyle()),
                    //       ],
                    //     ),
                    //     Switch(
                    //       // value: appStore.isDarkModeOn,
                    //       // activeColor: appColorPrimary,
                    //       // onChanged: (s) {
                    //       //   appStore.toggleDarkMode(value: s);
                    //       // },
                    //     )
                    //   ],
                    // ).onTap(
                    //       () {
                    //     // appStore.toggleDarkMode();
                    //   },
                    // ),
                    bankingOption(Banking_ic_security,
                        Banking_lbl_Change_Password, Banking_pinkColor)
                        .onTap(() {
                      // BankingChangePassword().launch(context);
                    }),
                    bankingOption(
                      Banking_ic_Share,
                      Banking_lbl_Share_Information_account,
                      Banking_greenLightColor,
                    ).onTap(() {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>ChoosePlanScreen()));
                    }),
                  ],
                ),
              ),
              // 16.height,
              // Container(
              //   padding: EdgeInsets.all(8),
              //   decoration: boxDecorationWithShadow(
              //     borderRadius: BorderRadius.circular(10),
              //     backgroundColor: context.cardColor,
              //   ),
              //   child: Column(
              //     children: <Widget>[
              //       10.height,
              //       bankingOption(Banking_ic_News, Banking_lbl_News,
              //               Banking_pinkLightColor)
              //           .onTap(() {
              //         // BankingNews().launch(context);
              //       }),
              //       bankingOption(
              //         Banking_ic_Chart,
              //         Banking_lbl_Rate_Information,
              //         Banking_greenLightColor,
              //       ).onTap(() {
              //         // BankingRateInfo().launch(context);
              //       }),
              //       bankingOption(Banking_ic_Pin, Banking_lbl_Location,
              //               Banking_greenLightColor)
              //           .onTap(() {
              //         // BankingLocation().launch(context);
              //       }),
              //       10.height,
              //     ],
              //   ),
              // ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    bankingOption(Banking_ic_TC, Banking_lbl_Term_Conditions,
                        Banking_greenLightColor)
                        .onTap(() {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TermsAndConditionActivity()));
                    }),
                    bankingOption(Banking_ic_Question,
                        Banking_lbl_Questions_Answers, Banking_palColor)
                        .onTap(() {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PrivacyPolicyActivity()));
                    }),
                    bankingOption(Banking_ic_Call, Banking_lbl_Contact,
                        Banking_pinkLightColor)
                        .onTap(() async{
                      await UrlLauncher.launch("tel://7066006625");
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (_) => const ContactUsActivity()));
                    }),
                    8.height,
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  children: <Widget>[
                    bankingOption(Banking_ic_Logout, Banking_lbl_Logout,
                        Banking_pinkColor)
                        .onTap(
                          () async {
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) => CustomDialog(),
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title:await changeLanguage('Are You Sure?'),
                            text:await changeLanguage('Do you want to logout'),
                            confirmBtnText: await changeLanguage('Yes'),
                            cancelBtnText: await changeLanguage('No'),
                            confirmBtnColor: Colors.green,
                            //customAsset: 'assets/new_images/logo.png',
                            onCancelBtnTap: () {
                            Navigator.pop(context);
                            },
                            onConfirmBtnTap: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setBool('_isLoggedIn', false);
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                            builder: (BuildContext context) =>
                            const LoginPageActivity()));
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0)),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        16.height,
        ChangedLanguage(text:Banking_lbl_Confirmation_for_logout,
            style: primaryTextStyle(size: 18))
            .onTap(() {
          finish(context);
        }).paddingOnly(top: 8, bottom: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ChangedLanguage(text:"Cancel", style: primaryTextStyle(size: 18)).onTap(
                  () {
                finish(context);
              },
            ).paddingRight(16),
            Container(width: 1.0, height: 40, color: Banking_greyColor)
                .center(),
            ChangedLanguage(text:"Logout",
                style: primaryTextStyle(size: 18, color: Banking_Primary))
                .onTap(
                  () {
                finish(context);
              },
            ).paddingLeft(16)
          ],
        ),
        16.height,
      ],
    ),
  );
}

Widget bankingOption(var icon, var heading, Color color) {
  return Container(
    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
    child: Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset(icon, color: color, height: 20, width: 20),
            16.width,
            FutureBuilder(future:changeLanguage(heading),builder: (context,i)=> i.hasData?Text(i.data,style: primaryTextStyle(),):Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,child: Card(
              child: SizedBox(
                height: height(context)*0.014,
                width: width(context)*0.25,
              ),
            )),)
            //ChangedLanguage(text:heading, style: primaryTextStyle()),
          ],
        ).expand(),
        Icon(Icons.keyboard_arrow_right, color: Color(0xFF747474)),
      ],
    ),
  );
}


const Banking_lbl_Confirmation_for_logout = "Do You want to Log Out ?";
const Banking_pinkLightColor = Color(0xFFE7586A);
const Banking_ic_Setting = "assets/Banking_ic_Setting.png";
const Banking_ic_security = "assets/Banking_ic_security.png";
const Banking_lbl_Change_Password = "Change Password";
const Banking_pinkColor = Color(0xFFE91E63);
const Banking_ic_Share = "assets/Banking_ic_Share.png";
const Banking_lbl_Share_Information_account = "Subscription";
const Banking_greenLightColor = Color(0xFF05E10E);
const Banking_ic_TC = "assets/Banking_ic_TC.png";
const Banking_lbl_Term_Conditions = "Terms & Conditions";
const Banking_ic_Question = "assets/Banking_ic_Question.png";
const Banking_lbl_Questions_Answers = "Privacy Policy";
const Banking_palColor = Color(0xFF4a536b);
const Banking_ic_Call = "assets/Banking_ic_Call.png";
const Banking_lbl_Contact = "Contact";
const Banking_ic_Logout = "assets/Banking_ic_Logout.png";
const Banking_lbl_Logout = "Logout";
const Banking_lbl_Setting = "Settings";

const Banking_Primary = Color(0xFFff9a8d);
const Banking_Secondary = Color(0xFF4a536b);
const Banking_ColorPrimaryDark = Color(0xFFFFF);

const Banking_TextColorPrimary = Color(0xFF070706);
const Banking_TextColorSecondary = Color(0xFF747474);
const Banking_TextColorWhite = Color(0xFFffffff);
const Banking_TextColorOrange = Color(0xFFF4413D);
const Banking_TextColorYellow = Color(0xFFff8c42);
const Banking_TextLightGreenColor = Color(0xFF8ed16f);

const Banking_app_Background = Color(0xFFf3f5f9);
const Banking_blackColor = Color(0xFF070706);
const Banking_view_color = Color(0XFFDADADA);
const Banking_blackLightColor = Color(0xFF242525);
const Banking_shadowColor = Color(0X95E9EBF0);
const Banking_greyColor = Color(0xFFA3A0A0);
const Banking_bottomEditTextLineColor = Color(0xFFDBD9D9);
const Banking_backgroundFragmentColor = Color(0xFFF7F5F5);

const Banking_BalanceColor = Color(0xFF8ed16f);
const Banking_whitePureColor = Color(0xFFffffff);
const Banking_subTitleColor = Color(0xFF5C5454);
const Banking_blueColor = Color(0xFF041887);
const Banking_blueLightColor = Color(0xFF41479B);
const Banking_RedColor = Color(0xFFD80027);
const Banking_skyBlueColor = Color(0xFF03A9F4);

const Banking_purpleColor = Color(0xFFAD3AC3);
const iconColorPrimary = Color(0xFFFFFFFF);
const iconColorSecondary = Color(0xFFA8ABAD);
const appSecondaryBackgroundColor = Color(0xFF131d25);
const appTextColorPrimary = Color(0xFF212121);
const appTextColorSecondary = Color(0xFF5A5C5E);
const appShadowColor = Color(0x95E9EBF0);
const appColorPrimaryLight = Color(0xFFF9FAFF);

// Dark Theme Colors
const appBackgroundColorDark = Color(0xFF121212);
const cardBackgroundBlackDark = Color(0xFF1F1F1F);
const color_primary_black = Color(0xFF131d25);
const appColorPrimaryDarkLight = Color(0xFFF9FAFF);
const iconColorPrimaryDark = Color(0xFF212121);
const iconColorSecondaryDark = Color(0xFFA8ABAD);
const appShadowColorDark = Color(0x1A3E3942);
const appColorPrimary = Color(0xFF1157FA);
const appLayout_background = Color(0xFFf8f8f8);

