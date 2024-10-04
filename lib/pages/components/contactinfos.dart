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
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontFamily: 'my'),
        ),
        SizedBox(
          width: screenSize.width - 30,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              fillColor: Colors.white,
              hintStyle: const TextStyle(color: Colors.white, fontFamily: 'my'),
              focusColor: Colors.black,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
