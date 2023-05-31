import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Screens/constant/Constant.dart';
import '../Widgets/Loading.dart';

class CommunityWebview extends StatefulWidget {
  const CommunityWebview({Key key}) : super(key: key);

  @override
  State<CommunityWebview> createState() => _CommunityWebviewState();
}

class _CommunityWebviewState extends State<CommunityWebview> {
  final _key = UniqueKey();
  bool isLoading=true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
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
          // extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              WebView(
                key: _key,
                onWebResourceError: (WebResourceError webviewer) {
                  print("Internet Error");
                },
                initialUrl: Uri.encodeFull("https://support.mapmycrop.com/portal/en/community/map-my-crop"),
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
