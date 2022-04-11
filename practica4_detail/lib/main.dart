import 'package:flutter/material.dart';
import 'package:practica4_detail/routes/routes.dart';
import 'package:practica4_detail/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: getApplicationRoutes(),
      home: SplashScreen(),
    );
  }
}
