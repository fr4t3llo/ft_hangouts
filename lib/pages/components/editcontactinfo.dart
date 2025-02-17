// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Editcontactinfo extends StatelessWidget {
  final Icon icon;
  final String text;
  final TextEditingController controller;

  const Editcontactinfo({
    super.key,
    required this.icon,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 5.0,
              spreadRadius: 1.1,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: icon,
            labelText: text,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
