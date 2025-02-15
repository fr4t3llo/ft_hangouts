import 'package:flutter/material.dart';

class Contactinfos extends StatelessWidget {
  const Contactinfos({super.key, required this.text, required this.hintText});
  final String text;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'my',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: screenSize.width - 30,
          child: TextField(
            // obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              fillColor: Colors.black87,
              labelStyle: const TextStyle(color: Colors.amber),
              hintStyle: const TextStyle(
                color: Colors.black87,
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
              ),
              focusColor: Colors.black,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
