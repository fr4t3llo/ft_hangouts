import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyColumn extends StatelessWidget {
  const MyColumn({super.key, required this.mycolor, required this.text, required this.icon});
  final Color mycolor;
  final String text;
  final IconButton icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: mycolor,
          child: icon,
        ),
        const SizedBox(height: 3),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontFamily: 'my'),
        )
      ],
    );
  }
}
