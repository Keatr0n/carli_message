import 'package:flutter/material.dart';

/// Now this thing is really cool.
///
/// or at least it would be if it was written properly.
class MessageCard extends StatefulWidget {
  MessageCard(this.message, this.onSave, {this.margin, this.reply});

  final String message;
  final void Function(String) onSave;
  final EdgeInsetsGeometry? margin;
  final String? reply;

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  TextEditingController _controller = TextEditingController();
  bool get hasSaved => oldText == _controller.text;

  String oldText = "";

  double saveButtonHeight = 0;
  double saveButtonWidth = 40;

  bool isAnimating = false;

  @override
  void initState() {
    if (widget.reply != null) {
      oldText = widget.reply!;
      _controller.text = widget.reply!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // now this is actually stupid, and it would be far better to handel this with it's own
    // separate variable. But instead, I just use the current height and width of the button
    // along with the [hasSaved] bool to check where it's supposed to be, and if it isn't there,
    // do the first half of the animation.
    if (!isAnimating) {
      if (hasSaved) {
        if (saveButtonWidth == 90) {
          isAnimating = true;
          saveButtonWidth = 39;
        }
      } else {
        if (saveButtonHeight == 0) {
          isAnimating = true;
          saveButtonWidth = 40;
          saveButtonHeight = 40;
        }
      }
    }

    return Card(
      margin: widget.margin,
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black26, width: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              widget.message,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              onChanged: (str) {
                setState(() {});
              },
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 0.5),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: 20),
            curve: Curves.easeOut,
            width: saveButtonWidth,
            height: saveButtonHeight,
            onEnd: () {
              // this is the second part of the animation, and it is equally stupid as the first half.
              // does end up looking pretty dope tho ngl
              if (saveButtonWidth == 39 && saveButtonHeight == 40) {
                saveButtonHeight = 0;
                setState(() {});
              } else if (saveButtonWidth == 40 && saveButtonHeight == 40) {
                saveButtonWidth = 90;
                setState(() {});
              } else {
                isAnimating = false;
                setState(() {});
              }
            },
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                height: 18,
                child: Text(
                  "Save",
                  overflow: TextOverflow.clip,
                ),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
              onPressed: () {
                oldText = _controller.text;
                widget.onSave(_controller.text);
                Future.delayed(Duration(milliseconds: 300)).then((value) {
                  setState(() {});
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
