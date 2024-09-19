import 'package:flutter/material.dart';

class TextfieldCustom extends StatelessWidget{

  final TextEditingController controller;
  final String hintText;
  final int maxLine;
  final TextInputAction textInputAction;

  const TextfieldCustom({super.key, required this.controller, required this.hintText, required this.maxLine, required this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      maxLines: maxLine,
      decoration: InputDecoration(
        hoverColor: Colors.blue,
        focusColor: Colors.blue,
        fillColor: Colors.transparent,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // validator: widget.validator,
    );
  }

}