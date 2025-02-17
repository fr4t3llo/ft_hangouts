import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/all_contacts.dart';
import 'package:ft_hangouts/pages/components/column.dart';
import 'package:ft_hangouts/pages/components/contactinfos.dart';
import 'package:ft_hangouts/pages/edit_contact.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'contact_page.dart';

class HomePage extends StatefulWidget {
  final Contact contact;

  const HomePage({super.key, required this.contact});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _sendMessage(String phoneNumber) async {
    final Uri smsUri = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      // Show error dialog if SMS app cannot be launched
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not launch messaging app'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // Show error dialog if phone app cannot be launched
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not launch phone app'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    final phoneNumber =
        contact.phones.isNotEmpty ? contact.phones.first.number : null;

    return Consumer<AppBarColorProvider>(
        builder: (context, appBarColorProvider, child) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: appBarColorProvider.appBarColor,
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
            '${contact.name.first} ${contact.name.last}',
            style:
                const TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => EditContact(contact: contact),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ),
                );
              },
              icon: const Icon(Iconsax.edit, color: Colors.black),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyColumn(
                      mycolor: const Color(0xFFF7941D),
                      text: 'message',
                      icon: IconButton(
                        onPressed: phoneNumber != null
                            ? () => _sendMessage(phoneNumber)
                            : null,
                        icon: const Icon(
                          Iconsax.message,
                          color: Color.fromARGB(255, 255, 128, 0),
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        image: contact.photo != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(contact.photo!),
                              )
                            : const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/default.jpg'),
                              ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      height: 150,
                      width: 150,
                    ),
                    MyColumn(
                      mycolor: const Color(0xFF28B33E),
                      text: 'call',
                      icon: IconButton(
                          onPressed: phoneNumber != null
                              ? () => _makePhoneCall(phoneNumber)
                              : null,
                          icon: const Icon(
                            Iconsax.call,
                            color: Color.fromARGB(255, 43, 170, 0),
                            size: 30,
                          )),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),

                    // Displaying the contact details
                    Contactinfos(
                      icon: const Icon(Icons.contacts),
                      text: 'First name',
                      hintText: contact.name.first,
                    ),
                    const SizedBox(height: 15),
                    Contactinfos(
                      icon: const Icon(Icons.contacts_rounded),
                      text: 'Last name',
                      hintText: contact.name.last,
                    ),
                    const SizedBox(height: 15),
                    Contactinfos(
                      icon: const Icon(Icons.phone),
                      text: 'Phone Number',
                      hintText: contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : 'No number available',
                    ),
                    const SizedBox(height: 15),
                    Contactinfos(
                      icon: const Icon(Icons.email),
                      text: 'Email',
                      hintText: contact.emails.isNotEmpty
                          ? contact.emails.last.address
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
    });
  }
}
