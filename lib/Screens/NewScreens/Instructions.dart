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
      //backgroundColor: Colors.transparent,
      backgroundColor: Color(0xffECB34F),
      title: ChangedLanguage(text:
        "How to Draw Farm?",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
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
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,color: Colors.green,),
                        SizedBox(width: 5,),
                        ChangedLanguage(text:"Do this...",style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/new_icons/instruct1.jpeg',fit: BoxFit.fill,height: height(context)*0.25,width: width(context)*0.4,)
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                        width: width(context)*0.4,
                        child: ChangedLanguage(text:'Proceed only after square is formed as shown above',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,))
                  ],//textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close,color: Colors.red,),
                        SizedBox(width: 5,),
                        ChangedLanguage(text:"Don't do this...",style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                        ),),

                      ],
                    ),
                    SizedBox(height: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/new_icons/instruct2.jpeg',fit: BoxFit.fill,height: height(context)*0.25,width: width(context)*0.4,)
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                        width: width(context)*0.4,
                        child: ChangedLanguage(text:'If it looks like the one above, re-add the field by clicking on the Clean option',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)))
                  ],//textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          SizedBox(height: 15,),
          Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/new_icons/instruct3.jpeg',fit: BoxFit.fill,height: height(context)*0.25,width: width(context)*0.4,)
              ),
              SizedBox(height: 10,),
              SizedBox(
                  width: width(context)*0.7,
                  child: ChangedLanguage(text:'Point in clockwise direction as you connect your field. So that your field should be rectangular. triangular or square.',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),))
            ],//textAlign: TextAlign.center,
          ),
          SizedBox(height: height(context)*0.05,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
           /* SizedBox(
              height: 35,
              width: width(context)*0.4,
              child: MaterialButton(
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChangedLanguage(text:'Watch Video',style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Inter",
                     // fontWeight: FontWeight.w600,
                    ),),
                    //SizedBox(width: 5,),
                    Icon(Icons.play_circle_outline, color: Colors.white,size: 20,)
                  ],
                ),
                  onPressed: (){
                  Navigator.pop(context);
                  }),
            ),*/
            SizedBox(
              height: 35,
              width: width(context)*0.9,

              child: MaterialButton(
                  color: Color(0xffECB34F),

                child: ChangedLanguage(text:'Next',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Inter",
                 // fontWeight: FontWeight.w600,
                ),),
                  onPressed: ()async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                     prefs.setBool("instructions", true);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewFarmsActivity()));
                  }),
            ),
          ],),
        ],
      ),
    );
  }
}
