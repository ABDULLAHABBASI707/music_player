import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/home_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 3), () {
      _navigateToHomeScreen();
    });
  }

  void _navigateToHomeScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/music_icon.jpeg')),
          SpinKitFadingCircle(
            color: Colors.red,
            size: 50,
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: 1.0,
              center: Text("100%"),
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.tealAccent.shade400,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: _navigateToHomeScreen,
            child: Text(
              "Let's Start",
              style: TextStyle(
                color: Colors.blueAccent,
                letterSpacing: 5,
                wordSpacing: 2,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
