import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String contactName = 'saifeddine kasmi';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 85, 103),
      appBar: AppBar(
        title: Center(
            child: Text(
          contactName,
          style: const TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
        )),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.amber),
              width: screenSize.width - 20,
              height: 300,
              child: Container(
                height: 10,
                width: screenSize.width - 250,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 219, 27, 27)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
