import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isLoading;
  bool showErrorPage = false;
  WebViewController? webViewController;
  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stay a little longer'),
        ),
      );
      return true;
    }
  }

  void showError() {
    setState(() {
      showErrorPage = true;
    });
  }

  void hideError() {
    setState(() {
      showErrorPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              WebView(
                initialUrl: 'http://173.82.226.239/',
                zoomEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (done) {
                  setState(() {
                    isLoading = false;
                    hideError();
                  });
                },
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onWebResourceError: (error) {
                  showError();
                },
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color(0xffEA6D50),
                    ))
                  : Container(),
              showErrorPage
                  ? Center(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        height: double.infinity,
                        width: double.infinity,
                        child: Text(
                            'An error occured. \nPlease check your internet and try again'),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    isLoading = true;
  }
}
