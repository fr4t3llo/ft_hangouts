import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
import 'package:ft_hangouts/pages/components/editcontactinfo.dart';
import 'package:ft_hangouts/translations/locale_keys.g.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.error_picking_image.tr()} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(LocaleKeys.choose_from_gallery.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(LocaleKeys.take_photo.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveContact() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (!await FlutterContacts.requestPermission(readonly: false)) {
        throw Exception('Permission denied');
      }

      final contact = await FlutterContacts.getContact(widget.contact.id);
      if (contact == null) {
        throw Exception('Could not find contact');
      }

      // Update contact details
      contact.name.first = firstNameController.text.trim();
      contact.name.last = lastNameController.text.trim();

      if (phoneController.text.trim().isNotEmpty) {
        contact.phones = [Phone(phoneController.text.trim())];
      }

      if (emailController.text.trim().isNotEmpty) {
        contact.emails = [Email(emailController.text.trim())];
      }

      // Update photo if a new one was selected
      if (_imageFile != null) {
        contact.photo = await _imageFile!.readAsBytes();
      }

      await contact.update();


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.contact_updated_successfully.tr()),
            backgroundColor: Colors.green,
          ),
        );

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
              style: const TextStyle(
                  fontFamily: 'my', fontWeight: FontWeight.bold),
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
                  // Contact Photo Section
                  GestureDetector(
                    onTap: _showImagePickerModal,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : widget.contact.photo != null
                                  ? MemoryImage(widget.contact.photo!)
                                  : null,
                          child:
                              _imageFile == null && widget.contact.photo == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: appBarColorProvider.appBarColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
      },
    );
  }
}
