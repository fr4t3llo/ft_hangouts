import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/all_contacts.dart';
import 'package:ft_hangouts/pages/components/column.dart';
import 'package:ft_hangouts/pages/components/contactinfos.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String contactName = 'Contact Page';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 106, 125),
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.backward1, color: Colors.black),
          onPressed: () => {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => AllContacts(),
                  // transitionDuration: Duration(seconds: 1),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ))
          },
        ),
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
                    MyColumn(
                      mycolor: const Color(0xFFD00000),
                      text: 'Edit',
                      icon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.profile_delete,
                              color: Colors.white, size: 20)),
                    ),
                    MyColumn(
                      mycolor: const Color(0xFFF7941D),
                      text: 'Edit',
                      icon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.message,
                              color: Colors.white, size: 20)),
                    ),
                    MyColumn(
                      mycolor: const Color(0xFF28B33E),
                      text: 'call',
                      icon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.call,
                              color: Colors.white, size: 20)),
                    ),
                    MyColumn(
                      mycolor: const Color(0xFFFF5FF9),
                      text: 'Edit',
                      icon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.edit,
                              color: Colors.white, size: 20)),
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
                  const Contactinfos(
                      text: 'First name', hintText: 'saifeddine'),
                  const SizedBox(height: 15),
                  const Contactinfos(text: 'Last name', hintText: 'kasmi'),
                  const SizedBox(height: 15),
                  const Contactinfos(
                      text: 'Number Phone', hintText: '+212661189840'),
                  const SizedBox(height: 60),
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
