import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mmc_master/Screens/NewScreens/AddNewFarmsActivity.dart';
import 'package:mmc_master/Screens/constant/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class DrawGuideActivity extends StatefulWidget {
  const DrawGuideActivity({Key key}) : super(key: key);

  @override
  State<DrawGuideActivity> createState() => _DrawGuideActivityState();
}

class _DrawGuideActivityState extends State<DrawGuideActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0.0,
      centerTitle: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffFDBE50),Color(0xffFD8342)]
          )
        ),
      ),
      //backgroundColor: Colors.transparent,
      backgroundColor: Color(0xffECB34F),
      title: ChangedLanguage(text:
        "How to Draw Farm?",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          /*fontFamily: "Inter"*/
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/new_images/back.png')),
    ),
      bottomNavigationBar:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: height(context)*0.05,
              width: width(context)*0.9,

              child: MaterialButton(
                  color: Color(0xff537503),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChangedLanguage(text:'Mark Farm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height(context)*0.02,
                          /*fontFamily: "Inter"*/
                          fontWeight: FontWeight.w300,
                        ),),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward,color: Colors.white,size: height(context)*0.025,)
                    ],
                  ),
                  onPressed: ()async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool("instructions", true);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewFarmsActivity()));
                  }),
            ),
          ),
        ],),
      body: Column(
        //dragStartBehavior:DragStartBehavior.down,
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 10,),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/illustrations/Guide1.png',fit: BoxFit.fill,height: height(context)*0.3,width: width(context)*0.85,)
              ),
              //SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/illustrations/wrong.png',height: 25,),
                  SizedBox(width: 10,),
                  ChangedLanguage(text:'Wrong way to mark farm',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                ],
              )
            ],//textAlign: TextAlign.center,
          ),
          SizedBox(height: 25,),
          Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/illustrations/Guide2.png',fit: BoxFit.fill,height: height(context)*0.3,width: width(context)*0.85,)
              ),
             // SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/illustrations/correct.png',height:25),
                  SizedBox(width: 10,),
                  ChangedLanguage(text:'Correct way to mark farm',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                ],
              )
            ],//textAlign: TextAlign.center,
          ),
         // SizedBox(height: height(context)*0.05,),

        ],
      ),
    );
  }
}
