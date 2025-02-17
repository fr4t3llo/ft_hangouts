import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/single_contact.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  String? _error;

  // Default AppBar color
  Color _appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetchContacts();
  }

  Future<void> _checkPermissionAndFetchContacts() async {
    try {
      // Request contact permission
      if (await FlutterContacts.requestPermission()) {
        // Fetch contacts (lightly fetched)
        List<Contact> contacts = await FlutterContacts.getContacts();

        // Fetch contacts (fully fetched, with properties and photos)
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);

        // If permission is granted and contacts are fetched successfully
        if (mounted) {
          setState(() {
            _contacts = contacts;
            _error = null; // Clear any previous error message
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _permissionDenied = true;
            _error = 'Permission denied to access contacts';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error accessing contacts: $e';
        });
      }
      debugPrint('Error in permission check: $e');
    }
  }

  // Function to change the AppBar color
  void _changeAppBarColor(Color color) {
    setState(() {
      _appBarColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppBarColorProvider>(
      builder: (context, appBarColorProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColorProvider.appBarColor,
            leading: IconButton(
              icon: const Icon(Iconsax.add, color: Colors.black),
              onPressed: () => {},
            ),
            title: const Text(
              'Contact',
              style: TextStyle(
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  // Show the PopupMenuButton to choose a color
                  showMenu<Color>(
                    context: context,
                    position: const RelativeRect.fromLTRB(
                        100, 50, 0, 0), // Position the menu
                    items: [
                      const PopupMenuItem<Color>(
                        value: Colors.blue,
                        child: Text('Blue'),
                      ),
                      const PopupMenuItem<Color>(
                        value: Colors.red,
                        child: Text('Red'),
                      ),
                      const PopupMenuItem<Color>(
                        value: Colors.green,
                        child: Text('Green'),
                      ),
                      const PopupMenuItem<Color>(
                        value: Colors.purple,
                        child: Text('Purple'),
                      ),
                    ],
                  ).then((value) {
                    if (value != null) {
                      appBarColorProvider
                          .updateColor(value); // Change the AppBar color
                    }
                  });
                },
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPermissionAndFetchContacts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_permissionDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please grant permission to access contacts in your device settings.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPermissionAndFetchContacts,
                child: const Text('Request Permission'),
              ),
            ],
          ),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, index) {
        final contact = _contacts![index];
        return ListTile(
          leading: contact.photo != null
              ? CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                )
              : CircleAvatar(
                  child: Text(
                    contact.displayName.isNotEmpty
                        ? contact.displayName[0].toUpperCase()
                        : '?',
                  ),
                ),
          title: Text(
            contact.displayName,
            style: const TextStyle(
              fontFamily: 'my',
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: contact.phones.isNotEmpty
              ? Text(
                  contact.phones.first.number,
                  style: const TextStyle(fontFamily: 'my'),
                )
              : null,
          onTap: () {
            // Navigate to HomePage and pass the selected contact
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(contact: contact), // Pass the contact data
              ),
            );
          },
        );
      },
    );
  }
}
