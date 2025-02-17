// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
import 'package:ft_hangouts/pages/components/editcontactinfo.dart';
import 'package:ft_hangouts/translations/locale_keys.g.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
class EditContact extends StatefulWidget {
  final Contact contact;

  const EditContact({super.key, required this.contact});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing contact data
    firstNameController =
        TextEditingController(text: widget.contact.name.first);
    lastNameController = TextEditingController(text: widget.contact.name.last);
    phoneController = TextEditingController(
      text: widget.contact.phones.isNotEmpty
          ? widget.contact.phones.first.number
          : '',
    );
    emailController = TextEditingController(
      text: widget.contact.emails.isNotEmpty
          ? widget.contact.emails.first.address
          : '',
    );
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
      // Request write permission
      if (!await FlutterContacts.requestPermission(readonly: false)) {
        throw Exception('Permission denied');
      }

      // Get a fresh copy of the contact
      final contact = await FlutterContacts.getContact(widget.contact.id);
      if (contact == null) {
        throw Exception('Could not find contact');
      }

      // Update contact details
      contact.name.first = firstNameController.text.trim();
      contact.name.last = lastNameController.text.trim();

      // Update phone
      if (phoneController.text.trim().isNotEmpty) {
        contact.phones = [Phone(phoneController.text.trim())];
      }

      // Update email
      if (emailController.text.trim().isNotEmpty) {
        contact.emails = [Email(emailController.text.trim())];
      }

      // Save changes
      await contact.update();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.contact_updated_successfully.tr()),
            backgroundColor: Colors.green,
          ),
        );

        // Return to contacts page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.error_updating_contact.tr()} $e'),
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            LocaleKeys.edit_contact.tr(),
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
                  icon: const Icon(Icons.contacts),
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
