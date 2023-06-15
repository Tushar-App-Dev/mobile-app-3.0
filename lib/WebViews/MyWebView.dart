
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      // Url='https://mapmycrop.store/mobiledashboard?api_key=${widget.api_key}';
      // print(widget.api_key);
      // url=true;
      // isLoading = false;
      var laguageSelect=prefs.getString('language');
      Url='https://mapmycrop.store/${laguageSelect}/mobiledashboard?api_key=${widget.api_key}';
    });
  }

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.api_key);
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
          body:Stack(
              children: [
                WebView(
                  key: _key,
                  onWebResourceError: (WebResourceError webviewer) {
                    print("Internet Error");
                  },
                  initialUrl: Uri.encodeFull(Url),
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
                isLoading ? Center( child: Loading(),)
                    : Stack(),
              ]
          )
      ),
    );
  }
}