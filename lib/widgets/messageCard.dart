import 'package:carli_message/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    required this.onResponseUpdate,
    this.margin,
    Key? key,
  }) : super(key: key);

  final Message message;
  final void Function(String) onResponseUpdate;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
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
              message.message,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextFormField(
              onChanged: (str) {
                onResponseUpdate(str);
              },
              initialValue: message.response,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: message.response.isNotEmpty ? Colors.lightGreen : Colors.black38, width: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
