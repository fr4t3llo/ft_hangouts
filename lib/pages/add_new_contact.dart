// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/components/editcontactinfo.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
import 'package:ft_hangouts/translations/locale_keys.g.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Request permission to add contacts
      if (!await FlutterContacts.requestPermission(readonly: false)) {
        throw Exception(LocaleKeys.permission_denied.tr());
      }

      // Create a new contact
      final newContact = Contact()
        ..name.first = firstNameController.text.trim()
        ..name.last = lastNameController.text.trim()
        ..phones = [Phone(phoneController.text.trim())]
        ..emails = [Email(emailController.text.trim())];

      // Insert the new contact
      await newContact.insert();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.contact_added_successfully.tr()),
            backgroundColor: Colors.green,
          ),
        );

        // Return to the contact list page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.error_adding_contact.tr()} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppBarColorProvider>(
        builder: (context, appBarColorProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appBarColorProvider.appBarColor,
          leading: IconButton(
            icon: const Icon(
              Iconsax.back_square,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ContactPage()),
            ),
          ),
          title: Text(
            LocaleKeys.add_contact.tr(),
            style:
                const TextStyle(fontFamily: 'my', fontWeight: FontWeight.bold),
          ),
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else
              IconButton(
                onPressed: _saveContact,
                icon: const Icon(
                  Icons.save_as_outlined,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Editcontactinfo(
                  
                  icon: Icon(Icons.contacts),
                  text: LocaleKeys.first_name.tr(),
                  controller: firstNameController,
                ),
                const SizedBox(height: 15),
                Editcontactinfo(
                  icon: const Icon(Icons.contacts_rounded),
                  text: LocaleKeys.last_name.tr(),
                  controller: lastNameController,
                ),
                const SizedBox(height: 15),
                Editcontactinfo(
                  icon: const Icon(Icons.phone),
                  text: LocaleKeys.phone_number.tr(),
                  controller: phoneController,
                ),
                const SizedBox(height: 15),
                Editcontactinfo(
                  icon: const Icon(Icons.email),
                  text: LocaleKeys.email.tr(),
                  controller: emailController,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
