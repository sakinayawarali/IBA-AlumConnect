import 'package:flutter/material.dart';

Widget buildRowWithButton(String text, String buttonText) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 18,
            fontFamily: 'Helvetica',
            color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle button tap here
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 14,
            fontFamily: 'Helvetica',),
          ),
        ),
      ],
    ),
  );
}
