
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Screens/constant/Constant.dart';
import '../Widgets/Loading.dart';
import '../constants/constants.dart';
class MyWebView extends StatefulWidget {
  final String api_key;
  const MyWebView({Key key,this.api_key}) : super(key: key);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {

  WebViewController controller ;

  final _key = UniqueKey();
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading=true;
  var Url;
  bool url=true;
  String mapData = '';

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Url='https://mapmycrop.store/mobiledashboard?api_key=${widget.api_key}';
      print(widget.api_key);
      url=true;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.api_key);
    return Container(
      height: height(context),
      width: width(context),
      child:Scaffold(
        //extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            //backgroundColor: Colors.transparent,
            backgroundColor: Color(0xffECB34F),
            title: ChangedLanguage(text:
              "My Farm Monitoring",
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
       body:SingleChildScrollView(
         child: Column(
           children: [

             Container(
               height: height(context)*0.88,
               child:  WebView(
                 key: _key,
                 onWebResourceError: (WebResourceError webviewer) {
                   print("Internet Error");
                 },
                 initialUrl: Uri.encodeFull(Url),//remove Uri.encodeFull
                 javascriptMode: JavascriptMode.unrestricted,
                 onWebViewCreated: (WebViewController webViewController) {
                   _controller.complete(webViewController);
                 },
                 onPageFinished: (finish) {
                   setState(() {
                     isLoading = false;
                   });
                 },
               ),
             ),
             isLoading ? Center( child: Loading(),)
                 : Stack(),
             // SizedBox(
             //   height: height(context)*0.01,
             // ),
             // Row(
             //   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/generic-farm-rating.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Generic Farm Rating',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/generic-farm-score.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Generic Farm Score',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/ai-farm-rating.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('AI Farm Rating',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/ai-farm-score.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('AI Farm Score',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/total-area.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Total Area',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/crop-name.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Crop Name',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/standard-yield-data.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Standard Yield Data',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/ai-yield-data.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('AI Yield Data',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Container(
             //   //height: height(context) * 0.14,
             //   width: width(context),
             //   padding: const EdgeInsets.all(4.0),
             //   constraints: BoxConstraints(minHeight:height(context) * 0.14),
             //   margin: const EdgeInsets.symmetric(horizontal:2,vertical: 5),
             //   decoration: BoxDecoration(
             //     borderRadius: BorderRadius.circular(10.0),
             //     color: Color(0xffd68060),
             //   ),
             //   child: Column(
             //     mainAxisAlignment: MainAxisAlignment.start,
             //     crossAxisAlignment: CrossAxisAlignment.start,
             //     children: [
             //       Padding(
             //         padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical:2.0),
             //         child: Text('Ideal temperature for planting warm season plants',style: TextStyle(fontWeight: FontWeight.w600, fontSize:14),),
             //       ),
             //       Padding(
             //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
             //         child: Text('- Warm season plants, such as cotton, rice and sugarcane, germinate best in temperatures between 21 to 30°C.(70 to 86F)'),
             //       ),
             //     ],
             //   ),
             // ),
             // Container(
             //   //height: height(context) * 0.14,
             //   width: width(context),
             //   //padding: const EdgeInsets.all(4.0),
             //   margin: const EdgeInsets.symmetric(horizontal:2,vertical: 5),
             //   constraints: BoxConstraints(minHeight:height(context) * 0.14),
             //   decoration: BoxDecoration(
             //     borderRadius: BorderRadius.circular(10.0),
             //     color: Colors.orange.shade100,
             //   ),
             //   child: Padding(
             //     padding: const EdgeInsets.symmetric(horizontal:2,vertical:2),
             //     child: Column(
             //       mainAxisAlignment: MainAxisAlignment.start,
             //       crossAxisAlignment: CrossAxisAlignment.start,
             //       children: [
             //         Padding(
             //           padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical:2),
             //           child: Text('Do not spray: No winds',style: TextStyle(fontWeight: FontWeight.w600, fontSize:14)),
             //         ),
             //         Padding(
             //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
             //           child: Text('- Still air may lead to vapor drift where finer droplets remain suspended in the air, prone to evaporation and drift long after spraying is completed.'),
             //         ),
             //       ],
             //     ),
             //   ),
             // ),
             // Container(
             //   //height: height(context) * 0.14,
             //   width: width(context),
             //   padding: const EdgeInsets.all(4.0),
             //   margin: const EdgeInsets.symmetric(horizontal:2,vertical: 5),
             //   constraints: BoxConstraints(minHeight:height(context) * 0.14),
             //   decoration: BoxDecoration(
             //     borderRadius: BorderRadius.circular(10.0),
             //     color: Color(0xffa6b1e1),
             //   ),
             //   child: Column(
             //     mainAxisAlignment: MainAxisAlignment.start,
             //     crossAxisAlignment: CrossAxisAlignment.start,
             //     children: [
             //       Padding(
             //         padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical:4),
             //         child: Text('Irrigate now',style: TextStyle(fontWeight: FontWeight.w600, fontSize:14)),
             //       ),
             //       Padding(
             //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
             //         child: Text('- Hot and dry conditons. Water all crops.'),
             //       ),
             //     ],
             //   ),
             // ),
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Soil Moisture At 0-1 cm',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Soil Moisture At 1-3 cm',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Soil Moisture At 27-81 cm',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Soil Temperature At 0 cm',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Soil Temperature At 6 cm',style: TextStyle(fontSize:11),),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Soil Temperature At 54 cm',style: TextStyle(fontSize:11),overflow:TextOverflow.clip),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
             // Row(
             //   children: [
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('Temperature At 2m',style: TextStyle(fontSize:11)),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //     5.width,
             //     Flexible(
             //       flex:1,
             //       child: ListTile(
             //         shape: RoundedRectangleBorder(
             //           borderRadius: BorderRadius.circular(12.0),
             //         ),
             //         tileColor: Colors.white,
             //         horizontalTitleGap:8.0,
             //         contentPadding:EdgeInsets.symmetric(horizontal:3.0),
             //         leading: Container(
             //           height: 40.0,
             //           width: 40.0,
             //           decoration: BoxDecoration(
             //             borderRadius: BorderRadius.circular(30.0),
             //             color: Colors.grey[200],
             //             image:DecorationImage(
             //               image: AssetImage('assets/illustrations/soil-quality-index.png'),
             //               fit: BoxFit.fitHeight,
             //             ),
             //           ),
             //         ),
             //         title: Text('UV Index',style: TextStyle(fontSize:11),maxLines:1,),
             //         subtitle: Text(
             //             ''
             //         ),
             //         onTap:(){
             //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
             //         },
             //       ),
             //     ),
             //   ],
             // ),
             // 5.height,
           ],
         ),
       ),
       // Stack(
       //   children: [
       //   WebviewScaffold(
       //     url:"https://mapmycrop.store/mobiledashboard?api_key=${widget.api_key}"
       //   ),
       //    isLoading ? Center( child: Loading(),)
       //        : Stack(),
       //  ],
       // ),
      ),
    );
  }
}
