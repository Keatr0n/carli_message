import 'package:carli_message/utils/saveData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is the first screen the user sees when they boot up the app.
/// 
/// This is where the user either pastes a message from their clipboard, or uses what they've got saved.
/// 
/// There's not really much else here, it's just ui.
class GetTextScreen extends StatefulWidget {
  GetTextScreen({Key? key, required this.onTextCallback, required this.onSavedDataCallback}) : super(key: key);

  final void Function(String) onTextCallback;

  final void Function(Map<String, String>) onSavedDataCallback;

  @override
  _GetTextScreenState createState() => _GetTextScreenState();
}

class _GetTextScreenState extends State<GetTextScreen> {
  void copyText() {
    Clipboard.getData("text/plain").then((value) {
      if (value != null && value.text != null) {
        widget.onTextCallback(value.text!);
      }
    });
  }

  void getSavedData() {
    SaveData.load().then((value) {
      widget.onSavedDataCallback(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Enter Carli's message",
            ),
            Center(
              child: ElevatedButton(
                child: Container(
                  child: Text("Copy from clipboard"),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                onPressed: () => copyText(),
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Container(
                  child: Text("Use saved data"),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                onPressed: () => getSavedData(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
