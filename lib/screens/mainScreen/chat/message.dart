import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final bool isSent;
  final String message;

  MessageWidget({required this.isSent, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSent ? Colors.blue[100] : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Text(message),
        ),
      ),
    );
  }
}