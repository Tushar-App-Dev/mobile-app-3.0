import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../constant/Constant.dart';
import 'FeedbackSuccessActivity.dart';

class FeedbackActivity extends StatefulWidget {
  const FeedbackActivity({Key key}) : super(key: key);

  @override
  State<FeedbackActivity> createState() => _FeedbackActivityState();
}

class _FeedbackActivityState extends State<FeedbackActivity> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xffECB34F),
        title: ChangedLanguage(text:'Feedback'),),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Image.asset('assets/new_images/feedback1.png')
            ),
            Container(
                height: height(context)*0.35,
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChangedLanguage(text:"Send your feedback"),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: description,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter a message",
                            fillColor: Color(0xffE9FFEB),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var api_key = prefs.getString('api_key');
                        var body = {
                          'feedback': description.text,

                        };
                       // http.post()
                       var response = await  http.post(Uri.parse('https://api.mapmycrop.store/feedback/?api_key=$api_key',
                        ),
                        headers: {
                         'accept':'application/json',
                          'Content-Type': "application/json"
                        },
                        body: jsonEncode(body));
                       print(response.statusCode);
                       print(response.body);
                       if(response.statusCode == 200){
                         description.clear();
                         Navigator.push(context,MaterialPageRoute(builder: (context)=> FeedBackSuccessAactivity( )));
                       }


                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:Color(0xffECB34F),
                        ),
                        height: height(context)*0.07,
                        width: width(context)*0.87,
                        child: Center(child: ChangedLanguage(text:'Submit',style: TextStyle(
                            color: Colors.white
                        ),)),

                      ),
                    )


                  ],
                )
            )

          ],
        ),
      ),
    );
  }
}

