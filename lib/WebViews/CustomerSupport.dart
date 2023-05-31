import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Screens/constant/Constant.dart';
import '../Widgets/Loading.dart';


class CustomerSupport extends StatefulWidget {
  const CustomerSupport({Key key}) : super(key: key);

  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}


class _CustomerSupportState extends State<CustomerSupport> {

  final _key = UniqueKey();
  bool isLoading=true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      width: width(context),
      color: Color(0xffECB34F),
      child:SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              WebView(
                key: _key,
                onWebResourceError: (WebResourceError webviewer) {
                  print("Internet Error");
                },
                initialUrl: Uri.encodeFull("https://mapmycrop.zohodesk.in/portal/en/kb/map-my-crop"),
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
              Align(
                alignment:Alignment.bottomLeft,
                child:Container(
                  height:60,
                  width: 60,
                  margin:EdgeInsets.symmetric(horizontal: 20.0,vertical:10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color.fromRGBO(0, 102,204,10.0),
                  ),
                  child: IconButton(
                    color: Colors.white,
                      onPressed:()=> Navigator.pop(context),
                      icon:Icon(Icons.arrow_back)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}