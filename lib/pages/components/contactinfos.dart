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
          padding: const EdgeInsets.only(left: 17.0, bottom: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          width: screenSize.width - 30,
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.center,
            // obscureText: true,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                color: Color.fromARGB(221, 124, 66, 0),
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
              ),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
