import 'package:flutter/material.dart';
import '../Model/Animation.dart';
import '../generated/l10n.dart';
import 'constant/Constant.dart';

class SoilTempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(S.of(context).SoilTemp,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',),textAlign: TextAlign.justify,),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(S.of(context).SoilTempShortDesc,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',),),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(S.of(context).SoilTempQue,textAlign: TextAlign.justify,style: TextStyle(fontWeight: FontWeight.bold,fontSize:15.0,fontFamily: 'GothicA1',),),
            ),
            Container(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation:5.0,
                  //color: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).SoilTemp1,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',),),
                  ),
                ),
              ),
            ),
            Container(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation:5.0,
                  //color: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).SoilTemp2,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',),),
                  ),
                ),
              ),
            ),
            Container(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation:5.0,
                  //color: Colors.green[100],
                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).SoilTemp3,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',),),
                  ),
              ),
              ),
            ),
            Container(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation:5.0,
                  //color: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).SoilTemp4,textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Screen2 extends StatefulWidget {
  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height:height(context)*0.34,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/soilTemp.jpg'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.85), BlendMode.dstATop),
                )

            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: FadeAnimation(1.6, Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text(S.of(context).SoilTemp, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
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
            height:height(context)*0.65,
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
                      child: Text(S.of(context).SoilTempShortDesc,textAlign: TextAlign.justify,style: TextStyle(fontSize:14.0,fontFamily: 'Quicksand',letterSpacing: 0.5),),//textAlign: TextAlign.justify,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(S.of(context).SoilTempQue,style: TextStyle(fontWeight: FontWeight.bold,fontSize:15.0,fontFamily: 'Quicksand',letterSpacing: 0.5),),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilTemp1,style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilTemp2,style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilTemp3,style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
                      ),
                    ),
                    Container(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).SoilTemp4,style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
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

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];