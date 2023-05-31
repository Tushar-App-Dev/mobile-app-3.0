import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Screens/constant/Constant.dart';
import '../Widgets/Loading.dart';


class PestisidesWebView extends StatefulWidget {

  @override
  _PestisidesWebViewState createState() => _PestisidesWebViewState();
}

class _PestisidesWebViewState extends State<PestisidesWebView> {

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
      child:SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              WebView(
                key: _key,
                onWebResourceError: (WebResourceError webviewer) {
                  print("Internet Error");
                },
                initialUrl: Uri.encodeFull('https://croplife.herokuapp.com/pest_recommend'),//remove Uri.encodeFull
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}


