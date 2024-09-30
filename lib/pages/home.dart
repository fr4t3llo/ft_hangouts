import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 85, 103),
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Create Contact',
          style: TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
