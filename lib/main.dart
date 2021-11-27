import 'package:carli_message/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CarliMessage());
}

class CarliMessage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Respond to Carli',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}
