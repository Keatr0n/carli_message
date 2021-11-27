import 'package:carli_message/models/message.dart';
import 'package:carli_message/widgets/expandableFAB.dart';
import 'package:carli_message/widgets/messageCard.dart';
import 'package:carli_message/utils/saveData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MessageCard> messageCards = [];
  List<Message> messages = [];

  bool loading = true;
  late final SaveData saveData;

  newMessage(String text) async {
    if (mounted) setState(() => loading = true);
    messages = text.split("\n\n").map((e) => Message(message: e)).toList();
    await saveData.saveAllMessages(messages);

    loading = false;
    buildMessageCards();
  }

  buildMessageCards() {
    messageCards = [];

    for (var i = 0; i < messages.length; i++) {
      messageCards.add(MessageCard(
        message: messages[i],
        onResponseUpdate: (response) {
          messages[i].response = response;
          saveData.saveSingleMessage(messages[i]);
        },
      ));
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    SaveData.withDocumentDirectory().then((val) async {
      saveData = val;
      messages = await saveData.loadAllMessages();
      loading = false;
      buildMessageCards();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // all this is pretty simple build stuff
    return Scaffold(
      floatingActionButton: ExpandableFab(distance: 100, children: [
        ActionButton(
          icon: Text("New Message"),
          onPressed: () {
            Clipboard.getData("text/plain").then((value) {
              if (value != null && value.text != null) {
                newMessage(value.text!);
              }
            });
          },
        ),
        ActionButton(
          icon: Text("Export"),
          onPressed: () {
            String finalMessage = "";
            messages.forEach((value) {
              if (value.response.isNotEmpty) {
                // just making sure there aren't needles \n lying around
                if (finalMessage.isNotEmpty) finalMessage += "\n\n";
                finalMessage += value.response.trim();
              }
            });
            Clipboard.setData(ClipboardData(text: finalMessage));

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Saved to clipboard"),
            ));
          },
        )
      ]),
      body: Container(
        // this isn't a ListView because ListViews destroy the state of the cards when they go
        // out of the users view which leads to a pretty poor ux.

        // now this can be solved by moving all the card state management to a separate object
        // so the widget itself isn't handling the state so it won't get destroyed when it goes
        // out of view, but for the time being, this works.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 35),
                child: Text(
                  "Messages",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 35),
                ),
              ),
              ...messageCards,
            ],
          ),
        ),
      ),
    );
  }
}
