import 'package:flutter/material.dart';
import 'package:horsepay_web/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HorsePay',
      theme: ThemeData(primaryColor: Color(0xffEA6D50)),
      home: const SplashScreen(),
    );
  }
}
