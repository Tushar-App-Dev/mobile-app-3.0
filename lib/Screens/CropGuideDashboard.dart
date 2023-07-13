import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'constant/Constant.dart';

class CropGuideDashboard extends StatefulWidget {
  @override
  _CropGuideDashboardState createState() => _CropGuideDashboardState();
}

class _CropGuideDashboardState extends State<CropGuideDashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Color(0xffECB34F),
        title: ChangedLanguage(text:
          "Crop Guides",
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
            child: Image.asset('assets/new_images/back.png')
        ),
      ),
      backgroundColor: Colors.grey[100],
      body:
      SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height(context)*0.17),
              makeDashboardItem(
                  "Global",
                   "assets/new_images/Global crop guide.png"
                  ),
              SizedBox(height:10.0),
              makeDashboardItem(
                  "India",
                  "assets/new_images/India_crop_guide.png",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding makeDashboardItem(String title, String img) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap:(){
          Navigator.pushNamed(context, '/${title}');
        },
        child: Container(
          width:width(context)*0.45,
            height: height(context)*0.20,
          decoration: BoxDecoration(
              //color: Colors.white,//Color(color),
              borderRadius: BorderRadius.circular(10),
            border: Border.all(color:Colors.black38, width: 1),
          ),
          child: Stack(
              children:[
                Container(
                  height: height(context)*0.20,
                  width:width(context)*0.45,
                  decoration: BoxDecoration(
                    //color: Colors.black,//Color(color),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              img))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: ChangedLanguage(text:title,style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                        )
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
