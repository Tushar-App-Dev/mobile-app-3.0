import 'package:flutter/material.dart';

class ContactUsActivity extends StatelessWidget {
  const ContactUsActivity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Color(0xffECB34F),
          title: Text(
            "Contact Us",
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
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Image.asset("assets/images/mapmycrop_logo1.png",height:150,)),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("India Office",textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("B-10 Hive,The Mills at RBCC, Raja Bahadur Mill Rd, behind Sheraton Grand Hotel, Sangamvadi, Pune, Maharashtra 411001\n\n"
                          "Phone Number: +91 7066006625\n"
                          "Mail: neil@mapmycrop.com",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("New York Office", textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w700,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("One World Trade Center Suite 8500, New York(NY) 10007 USA\n\n"
                          "Phone Number: +1 9173100861\n"
                          "Mail: info@mapmycrop.com",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
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
