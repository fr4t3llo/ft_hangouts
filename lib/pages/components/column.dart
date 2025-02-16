import 'package:flutter/material.dart';

class MyColumn extends StatelessWidget {
  const MyColumn(
      {super.key,
      required this.mycolor,
      required this.text,
      required this.icon});
  final Color mycolor;
  final String text;
  final IconButton icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              // border: Border.all(),
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(5),
            ),
            child: icon,),
        const SizedBox(height: 3),
        Text(
          text,
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'my',
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
