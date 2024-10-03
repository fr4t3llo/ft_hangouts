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
      backgroundColor: const Color.fromARGB(255, 0, 85, 103),
      appBar: AppBar(
        title: Center(
            child: Text(
          contactName,
          style: const TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
        )),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 25,
                          blurStyle: BlurStyle.normal,
                          color: Color.fromARGB(255, 59, 59, 59),
                          offset: Offset.zero,
                          spreadRadius: 0.05,
                        ),
                      ],
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/skasmi.jpeg'),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    height: 150,
                    width: 150,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Iconsax.edit5, color: Colors.white),
                      onPressed: () {
                        debugPrint("Edit Picture");
                      },
                    ),
                  ),
                ],
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
                          backgroundColor: const Color(0xFFD00000),
                          child: IconButton(
                            icon: const Icon(
                              size: 20,
                              Iconsax.profile_delete,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Delete',
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'my'),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFF7941D),
                          child: IconButton(
                            icon: const Icon(
                              size: 20,
                              Iconsax.message,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Message',
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'my'),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF28B33E),
                          child: IconButton(
                            icon: const Icon(
                              size: 20,
                              Iconsax.call,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Call',
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'my'),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFFF5FF9),
                          child: IconButton(
                            icon: const Icon(
                              size: 20,
                              Iconsax.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Edit',
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'my'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'contact infos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'my'),
                        ),
                      )),
                  const SizedBox(height: 30),
                  const Text(
                    'First name',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                      width: screenSize.width - 30,
                      child: const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                                color: Colors.white, fontFamily: 'my2'),
                            focusColor: Colors.black,
                            hintText: 'saifeddine',
                          ))),
                  const SizedBox(height: 15),
                  const Text(
                    'Last name',
                    style: TextStyle(color: Colors.white, fontFamily: 'my'),
                  ),
                  SizedBox(
                      width: screenSize.width - 30,
                      child: const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                                color: Colors.white, fontFamily: 'my2'),
                            focusColor: Colors.black,
                            hintText: 'kasmi',
                          ))),
                  const SizedBox(height: 15),
                  const Text(
                    'Number phone',
                    style: TextStyle(color: Colors.white, fontFamily: 'my'),
                  ),
                  SizedBox(
                    width: screenSize.width - 30,
                    child: const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'my',
                            fontSize: 15),
                        focusColor: Colors.black,
                        hintText: '+212661189840',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'my',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
