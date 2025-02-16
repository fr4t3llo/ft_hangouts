import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/all_contacts.dart';
import 'package:ft_hangouts/pages/components/column.dart';
import 'package:ft_hangouts/pages/components/contactinfos.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_contacts/flutter_contacts.dart'; // Import Flutter Contacts package
import 'contact_page.dart';

class HomePage extends StatefulWidget {
  final Contact
      contact; // This is the contact passed from the contact list page

  const HomePage(
      {super.key, required this.contact}); // Constructor accepting a contact

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Get contact details from the widget
    final contact = widget.contact;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.back_square, color: Colors.black),
          onPressed: () => {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ContactPage(),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
            )
          },
        ),
        title: Text(
          '${contact.name.first} ${contact.name.last}', // Use contact name
          style: const TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.edit,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                      image: contact.photo != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(contact
                                  .photo!), // Using the photo from the contact
                            )
                          : const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/skasmi.jpeg'), // A default image when no photo is available
                            ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    height: 150,
                    width: 150,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0, left: 15, right: 15, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyColumn(
                      mycolor: const Color(0xFFD00000),
                      text: 'delete',
                      icon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.profile_delete,
                              color: Colors.white, size: 20)),
                    ),
                    MyColumn(
                      mycolor: const Color(0xFFF7941D),
                      text: 'message',
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
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),

                  // Displaying the contact details
                  Contactinfos(
                    text: 'First name',
                    hintText: contact.name.first,
                  ),
                  const SizedBox(height: 15),
                  Contactinfos(
                    text: 'Last name',
                    hintText: contact.name.last,
                  ),
                  const SizedBox(height: 15),
                  Contactinfos(
                    text: 'Phone Number',
                    hintText: contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : 'No number available',
                  ),
                  const SizedBox(height: 15),
                  Contactinfos(
                    text: 'Email',
                    hintText: contact.phones.isNotEmpty
                        ? contact.emails.first.address
                        : 'No Email available',
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
