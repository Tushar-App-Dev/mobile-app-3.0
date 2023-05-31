import 'package:flutter/material.dart';

import '../constant/Constant.dart';

class FeedBackSuccessAactivity extends StatefulWidget {
  const FeedBackSuccessAactivity({Key key}) : super(key: key);

  @override
  State<FeedBackSuccessAactivity> createState() => _FeedBackSuccessAactivityState();
}

class _FeedBackSuccessAactivityState extends State<FeedBackSuccessAactivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffECB34F),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')
        ),
        title: Text('Feedback'),),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height(context)*0.1,
            ),
            Container(
              height: height(context)*0.5,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 25),
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
                children: [
                  Image.asset('assets/new_images/feedback.png'),
                  Text('Thank you!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(height: 30,),
                  Text('Your Feedback successfully submitted'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
