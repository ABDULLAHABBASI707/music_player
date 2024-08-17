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
  double _progress = 0.2;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.2;
        } else {
          timer.cancel();
          //_navigateToHomeScreen();
        }
      });
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
      backgroundColor: Colors.tealAccent.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Circular border radius
              child: Image.asset(
                'assets/music.png',
                width: 300, // Adjust the size as needed
                height: 150, // Adjust the size as needed
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 20.0,
              percent: _progress,
              center: Text("${(_progress * 100).toInt()}%"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.tealAccent.shade400,
              backgroundColor: Colors.teal.shade100,
              barRadius: Radius.circular(10),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SpinKitFadingCircle(
            color: Colors.green.shade700,
            size: 50,
          ),
          SizedBox(
            height: 25,
          ),
          TextButton(
            onPressed: _navigateToHomeScreen,
            child: const Text(
              "Let's Start",
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 5,
                wordSpacing: 2,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
