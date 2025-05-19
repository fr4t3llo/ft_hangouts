import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/add_new_contact.dart';
import 'package:ft_hangouts/pages/background_timer.dart';
import 'package:ft_hangouts/pages/single_contact.dart';
import 'package:ft_hangouts/translations/locale_keys.g.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppBarColorProvider>(
      builder: (context, appBarColorProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: appBarColorProvider.appBarColor,
            leading: IconButton(
              icon: const Icon(Iconsax.add, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddContactPage(),
                  ),
                );
              },
            ),
            title: Text(
              LocaleKeys.contact.tr(),
              style: const TextStyle(
                fontFamily: 'my',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  // Show the PopupMenuButton to choose a color or language
                  showMenu<dynamic>(
                    context: context,
                    color: Colors.white,
                    position: const RelativeRect.fromLTRB(
                        100, 50, 0, 0), // Position the menu
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          LocaleKeys.app_bar_color.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontFamily: 'my',
                              fontSize: 18),
                        ),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.white,
                        child: Text(
                            style: const TextStyle(
                                fontFamily: 'my', fontWeight: FontWeight.bold),
                            LocaleKeys.white.tr()),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.blue,
                        child: Text(
                            style: const TextStyle(
                                fontFamily: 'my', fontWeight: FontWeight.bold),
                            LocaleKeys.blue.tr()),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.red,
                        child: Text(
                            style: const TextStyle(
                                fontFamily: 'my', fontWeight: FontWeight.bold),
                            LocaleKeys.red.tr()),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.green,
                        child: Text(
                            style: const TextStyle(
                                fontFamily: 'my', fontWeight: FontWeight.bold),
                            LocaleKeys.green.tr()),
                      ),
                      PopupMenuItem<Color>(
                        value: Colors.purple,
                        child: Text(
                            style: const TextStyle(
                                fontFamily: 'my', fontWeight: FontWeight.bold),
                            LocaleKeys.purple.tr()),
                      ),
                      // Divider to separate color options from language options
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          LocaleKeys.language.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontFamily: 'my',
                              fontSize: 18),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'en',
                        onTap: () => {context.setLocale(const Locale('en'))},
                        child: const Text(
                          'English 🇺🇸',
                          style: TextStyle(
                            fontFamily: 'my',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'es',
                        onTap: () => {context.setLocale(const Locale('es'))},
                        child: const Text(
                          'Spanich 🇪🇸',
                          style: TextStyle(
                            fontFamily: 'my',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value != null) {
                      if (value is Color) {
                        appBarColorProvider
                            .updateColor(value); // Change the AppBar color
                      } else if (value is String) {
                        // Language change button - onPressed is empty as requested
                        // This is where language change logic would go
                      }
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
                // LocaleKeys.error.tr(),
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPermissionAndFetchContacts,
                child: const Text(LocaleKeys.retry),
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
              Text(
                LocaleKeys.please_grant_permission.tr(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPermissionAndFetchContacts,
                child: Text(LocaleKeys.request_permission.tr()),
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
