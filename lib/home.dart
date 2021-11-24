import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horsepay_web/utils/constants.dart';
import 'package:horsepay_web/widgets/button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isLoading;
  late bool showErrorPage;
  WebViewController? webViewController;
  void _exitDialog() {
    AlertDialog dialog = AlertDialog(
      content: Container(
          width: 260.0,
          height: 200,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0x00ffffff),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0),
              const Text("Do you want to exit the app?"),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Button(
                        buttonText: 'NO',
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        color: Colors.white,
                        textColor: kMainColor,
                        borderColor: kMainColor,
                        borderRadius: 0,
                        buttonHeight: 40),
                  ),
                  Expanded(
                    flex: 1,
                    child: Button(
                        buttonText: 'YES',
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        color: kMainColor,
                        textColor: Colors.white,
                        borderColor: kMainColor,
                        borderRadius: 0,
                        buttonHeight: 40),
                  ),
                ],
              ),
            ],
          )),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    } else {
      _exitDialog();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Stay a little longer'),
      //   ),
      // );
    }
    return true;
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
                  });
                },
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onWebResourceError: (error) {
                  setState(() {
                    showErrorPage = true;
                    isLoading = true;
                    // ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar(
                    //   content: Text('🙄 ${showErrorPage.toString()}'),
                    // ),
                    // );
                  });
                  // showError();
                },
              ),
              isLoading
                  ? Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Color(0xffEA6D50),
                      )),
                    )
                  : Container(),
              showErrorPage
                  ? Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.asset(
                                "images/wifi_off_icon.png",
                                color: Colors.grey,
                                height: 110.0,
                                width: 110.0,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              const Text(
                                'An error occurred. \nPlease check your internet and try again',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Button(
                                  buttonText: 'Reload',
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      showErrorPage = false;
                                    });
                                    webViewController!.reload();
                                  },
                                  color: Colors.white,
                                  textColor: kMainColor,
                                  borderColor: kMainColor,
                                  borderRadius: 0,
                                  buttonHeight: 40),
                            ],
                          ),
                        ),
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
    showErrorPage = false;
  }
}
