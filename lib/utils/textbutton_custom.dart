import 'package:flutter/material.dart';

class TextbuttonCustom extends StatelessWidget{

  final int color;
  final String text;
  final Function()? onPress;

  const TextbuttonCustom({super.key, required this.color, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
                  (states) => Color(color)),
          minimumSize: WidgetStateProperty.all(Size(
              MediaQuery.of(context).size.width, 50))),
      onPressed: onPress,
      child: Text(text,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold)),
    );
  }

}