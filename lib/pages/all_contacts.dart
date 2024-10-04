import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/home.dart';
import 'package:iconsax/iconsax.dart';

class AllContacts extends StatelessWidget {
  const AllContacts({super.key});
  final String contactName = 'saifeddine';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Iconsax.backward1, color: Colors.black),
            onPressed: () => {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePage(),
                  // transitionDuration: Duration(seconds: 1),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ),
              ),
            },
          ),
          title: Center(
            child: Text(
              contactName,
              style: const TextStyle(
                  fontFamily: 'my', fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 75, 75, 75),
      ),
    );
  }
}
