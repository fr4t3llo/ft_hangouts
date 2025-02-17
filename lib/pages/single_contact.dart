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
    // Format phone number by removing any spaces, dashes, or parentheses
    final formattedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final Uri smsUri = Uri.parse('sms:$formattedNumber');

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open Messages app'),
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
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error opening Messages: $e'),
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
    // Format phone number by removing any spaces, dashes, or parentheses
    final formattedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final Uri callUri = Uri.parse('tel:$formattedNumber');

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Error',
                style: TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Could not open Phone app',
                style: TextStyle(fontFamily: 'my'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontFamily: 'my'),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error making call: $e'),
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

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'Delete Contact',
                style: TextStyle(
                  fontFamily: 'my',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this contact?\nThis action cannot be undone.',
            style: TextStyle(fontSize: 16, fontFamily: 'my'),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(
                Icons.close_rounded,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 20,
              ),
              label: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(true);
                await widget.contact.delete();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactPage()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
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
              style: const TextStyle(
                  fontFamily: 'my', fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          EditContact(contact: contact),
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
                                  image:
                                      AssetImage('assets/images/default.jpg'),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 40),
                      // Delete button at the bottom
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 50 / 100,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: const Text(
                            'Delete Contact',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _showDeleteConfirmation,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
