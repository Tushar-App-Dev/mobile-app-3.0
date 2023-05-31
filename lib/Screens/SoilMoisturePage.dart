import 'package:flutter/material.dart';

import '../Model/Animation.dart';
import '../generated/l10n.dart';
import 'constant/Constant.dart';

class Screen3 extends StatefulWidget {
  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0e0d0c),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height:height(context)*0.40,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/soilMoisture.jpg'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.85), BlendMode.dstATop),
                )
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: FadeAnimation(1.6, Container(
                    margin: EdgeInsets.only(top: 150),
                    child: Center(
                      child: Text(S.of(context).SoilMoist, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                    ),
                  )),
                ),
                Positioned(
                  child: Container(
                      margin: EdgeInsets.only(left: 20,top:35),
                      child:IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, icon:Icon(Icons.arrow_back, color: Colors.white),

                      )
                  ),
                )
              ],
            ),
          ),
          Container(
            height:height(context)*0.58,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(S.of(context).SoilMoist1,style: TextStyle(fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(S.of(context).SoilMoist2,style: TextStyle(fontWeight: FontWeight.bold,fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5),),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilMoist3,style: TextStyle(fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilMoist4,style: TextStyle(fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilMoist5,style: TextStyle(fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilMoist6,style: TextStyle(fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
