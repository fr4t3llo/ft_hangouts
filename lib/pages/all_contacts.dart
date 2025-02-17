import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';

class AllContacts extends StatelessWidget {
  const AllContacts({super.key});
  final String contactName = 'saifeddine';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 99, 25, 25),
        leading: IconButton(
          icon: const Icon(Iconsax.backward1, color: Colors.black),
          onPressed: () => {
          
          },
        ),
        title: Center(
          child: Text(
            contactName,
            style:
                const TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 75, 75, 75),
    );
  }
}
