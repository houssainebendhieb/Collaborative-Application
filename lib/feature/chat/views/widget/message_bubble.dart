import 'package:flutter/material.dart';

class messageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  const messageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe == false ? Alignment.centerLeft : Alignment.centerRight,
      child: isMe == true
          ? messageDecorationForMe(message: message)
          : messageDecoration(message: message),
    );
  }
}

class messageDecoration extends StatelessWidget {
  const messageDecoration({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 32),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            color: Colors.blue),
        child: Text(message, style: TextStyle(color: Colors.white)));
  }
}

class messageDecorationForMe extends StatelessWidget {
  const messageDecorationForMe({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 32),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            ),
            color: Colors.orange),
        child: Text(message, style: TextStyle(color: Colors.white)));
  }
}
