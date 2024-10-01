import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String contactName = 'saifeddine kasmi';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 85, 103),
      appBar: AppBar(
        title: Center(
            child: Text(
          contactName,
          style: TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
        )),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      blurStyle: BlurStyle.normal,
                      color: Colors.black,
                      offset: Offset.zero,
                      spreadRadius: 2,
                    ),
                  ],
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/me.png')),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              height: 230,
              width: screenSize.width - 30,
              // decoration: BoxDecoration(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0, left: 15, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFD00000),
                        child: IconButton(
                          icon: const Icon(
                            size: 30,
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontFamily: 'my'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFF7941D),
                        child: IconButton(
                          icon: const Icon(
                            size: 30,
                            Icons.message,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Message',
                        style: TextStyle(color: Colors.white, fontFamily: 'my'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF28B33E),
                        child: IconButton(
                          icon: const Icon(
                            size: 30,
                            Icons.call,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Call',
                        style: TextStyle(color: Colors.white, fontFamily: 'my'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFFF5FF9),
                        child: IconButton(
                          icon: const Icon(
                            size: 30,
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontFamily: 'my'),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
