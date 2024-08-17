import 'package:flutter/material.dart';

class ArtistScreen extends StatelessWidget {
  final String artistName;

  ArtistScreen({required this.artistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artist'),
      ),
      body: Center(
        child: Text(
          artistName,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
