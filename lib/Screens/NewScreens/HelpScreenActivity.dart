import 'package:flutter/material.dart';

class HelpScreenActivity extends StatelessWidget {
  const HelpScreenActivity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xffECB34F),
        title: Text(
          "Help",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')
        ),
      ),
      body:SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("If there are any questions regarding this privacy policy you may contact us using the information below",
                  // "Address :"
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Address :",
                  //textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Open Sans",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("B-10 Hive, The Mills at RBCC, Raja Bahadur Mill Rd, behind Sheraton Grand Hotel,Sangamvadi, Pune, Maharashtra 411001\n\n"
                    "Phone Number : +91 96650 50993\n"
                    "Email : info@mapmycrop.com",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
