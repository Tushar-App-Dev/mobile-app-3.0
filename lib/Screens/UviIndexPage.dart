import 'package:flutter/material.dart';

import '../Model/Animation.dart';
import '../generated/l10n.dart';
import 'constant/Constant.dart';

class Screen4 extends StatefulWidget {
  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height:height(context)*0.50,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/log3.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.90), BlendMode.dstATop),
                )
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: FadeAnimation(1.6, Container(
                    margin: EdgeInsets.only(top: height(context)*0.35),
                    child: Center(
                      child: Text(S.of(context).UVI, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
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
            height:height(context)*0.49,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
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
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).UVIData1,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.1)),//textAlign: TextAlign.justify,letterSpacing: 0.5
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).UVIData2,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.1)),//textAlign: TextAlign.justify,
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
