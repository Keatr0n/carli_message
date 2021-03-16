import 'package:carli_message/screens/getText.dart';
import 'package:carli_message/screens/writeText.dart';
import 'package:flutter/material.dart';


/// This is the closest thing the app has to state management
/// 
/// It basically takes the data from the [getText] screen and gives it to the [writeText] screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _text = "";
  Map<String, String> _data = {};
  bool _hasTextData = false;

  @override
  Widget build(BuildContext context) {
    if (_hasTextData) {
      return WriteText(
        text: _text,
        savedData: _data,
      );
    }
    return GetTextScreen(
      onSavedDataCallback: (data) {
        setState(() {
          _data = data;
          _hasTextData = true;
        });
      },
      onTextCallback: (text) {
        setState(() {
          _text = text;
          _hasTextData = true;
        });
      },
    );
  }
}
