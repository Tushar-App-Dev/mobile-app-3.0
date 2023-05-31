import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        title: Text(
          'Contact Us',
          style:TextStyle(color: Colors.black)
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Image.asset("assets/images/mapmycrop_logo1.png",height:200,)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  shadowColor:Colors.blueGrey,
                  elevation: 5.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("India Office",textAlign: TextAlign.justify,style: TextStyle(color:Colors.black,fontSize:18.0,fontWeight:FontWeight.bold,fontFamily: 'GothicA1'),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("B-10 Hive,The Mills at RBCC,Raja Bahadur Mill Rd, behind Sheraton Grand Hotel,Sangamvadi, Pune, Maharashtra 411001\n\n"
                              " Phone Number: +91 96650 50993\n"
                              " Mail: neil@mapmycrop.com",
                            textAlign: TextAlign.justify,
                            style:TextStyle(
                                color: Colors.black,fontFamily: 'GothicA1',),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  shadowColor:Colors.blueGrey,
                  elevation: 5.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text("New York Office",textAlign: TextAlign.justify,style: TextStyle(color:Colors.black,fontSize:18.0,fontWeight:FontWeight.bold,fontFamily: 'GothicA1',),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("One World Trade Center Suite 8500,New York NY 10007 USA\n\n"
                              " Phone Number: +91 96650 50993\n"
                              " Mail: info@mapmycrop.com",
                            textAlign: TextAlign.justify,
                            style:TextStyle(
                                color: Colors.black,fontFamily: 'GothicA1',),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}