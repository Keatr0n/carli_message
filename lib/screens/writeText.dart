import 'package:carli_message/widgets/messageCard.dart';
import 'package:carli_message/utils/saveData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WriteText extends StatefulWidget {
  WriteText({this.text, this.savedData});

  final String? text;
  final Map<String, String>? savedData;
  @override
  _WriteTextState createState() => _WriteTextState();
}

class _WriteTextState extends State<WriteText> {
  List<MessageCard> messageCards = [];

  Map<String, String> saveData = {};

  bool saving = false;

  @override
  void initState() {
    if (widget.text != null && widget.text!.isNotEmpty) {
      // split the paragraphs into a list
      List<String> messages = widget.text!.split("\n\n");
      messages.forEach((element) {
        // if the paragraph isn't empty make a new message card
        // and add the paragraph to the saveData for later
        
        if (element.isNotEmpty) {
          saveData[element] = "";
          messageCards.add(MessageCard(
            element,
            (str) {
              saveData[element] = str;
              if (!saving) {
                saving = true;
                SaveData.save(saveData).then((_) {
                  saving = false;
                });
              }
            },
          ));
        }
      });
    } else if (widget.savedData != null && widget.savedData!.isNotEmpty) {
      widget.savedData!.forEach((key, value) {
        // add the saved data we got from the home screen to the save data in here to make modifying 
        // and saving easier

        // and for the record, there are better ways of doing this
        // but I really don't care. It works and that's what matters
        saveData[key] = value;
        messageCards.add(MessageCard(
          key,
          (str) {
            saveData[key] = str;
            if (!saving) {
              saving = true;
              SaveData.save(saveData).then((_) {
                saving = false;
              });
            }
          },
          // also pre-populate the reply
          reply: value,
        ));
      });
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    // all this is pretty simple build stuff
    return Scaffold(
      body: Container(
        // this isn't a ListView because ListViews destroy the state of the cards when they go
        // out of the users view which leads to a pretty poor ux.

        // now this can be solved by moving all the card state management to a separate object
        // so the widget itself isn't handling the state so it won't get destroyed when it goes
        // out of view, but for the time being, this works.
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 35),
                child: Text(
                  "Messages",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 35),
                ),
              ),
              ...messageCards,
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26, width: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Build Message",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    String finalMessage = "";
                    saveData.forEach((key, value) {
                      if (value.isNotEmpty) {
                        // just making sure there aren't needles \n lying around
                        if (finalMessage.isNotEmpty) finalMessage += "\n\n";
                        finalMessage += value.trim();
                      }
                    });
                    Clipboard.setData(ClipboardData(text: finalMessage));

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Saved to clipboard"),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
