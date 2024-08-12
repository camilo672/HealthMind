import 'package:flutter/material.dart';
import 'package:phsycho/components/item/color.dart';
import "styles.dart";

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Button({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton( 

      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
// Apply your custom buttonTextStyle
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0), 
 // Customize button shape
        ),
      ),
      child: Text(text,style: TextStyle(
        color: white
      ),), // Directly use the "text" property here
    );
  }
}

