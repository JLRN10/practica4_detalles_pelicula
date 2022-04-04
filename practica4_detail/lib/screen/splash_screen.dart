import 'package:flutter/material.dart';
import 'package:practica4_detail/screen/popular_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
        navigateRoute: PopularScreen(),
        backgroundColor: Colors.black,
        duration: 3000,
        imageSrc: "assets/metflix_logo.gif",
        imageSize: 200,
        text: "Cine Club Metflix",
        textStyle: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Comics Sams"));
  }
}
