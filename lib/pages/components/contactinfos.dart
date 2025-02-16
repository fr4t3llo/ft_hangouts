import 'package:flutter/material.dart';

class Contactinfos extends StatelessWidget {
  const Contactinfos({
    super.key,
    required this.text,
    required this.hintText,
    required this.icon,
  });

  final String text;
  final String hintText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17.0, bottom: 8),
            child: Row(
              children: [
                IconTheme(
                  data: const IconThemeData(
                    color: Color.fromARGB(221, 124, 66, 0),
                    size: 24,
                  ),
                  child: icon,
                ),
                const SizedBox(width: 15),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'my',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenSize.width - 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(221, 124, 66, 0).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: TextField(
                readOnly: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'my',
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(221, 124, 66, 0),
                    fontFamily: 'my',
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
