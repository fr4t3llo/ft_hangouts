// import 'package:contacts_service/contacts_service.dart';
// import 'package:easy_sms_receiver/easy_sms_receiver.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SMSContactHandler {
//   final _smsReceiver = EasySmsReceiver();

//   Future<void> initialize() async {
//     // Request necessary permissions
//     await requestPermissions();
    
//     // Start listening for SMS
//     _smsReceiver.onSmsReceived.listen((SmsInfo sms) {
//       handleIncomingSMS(sms);
//     });
//   }

//   Future<void> requestPermissions() async {
//     // Request SMS and Contacts permissions
//     await Permission.sms.request();
//     await Permission.contacts.request();
//   }

//   Future<void> handleIncomingSMS(SmsInfo sms) async {
//     final String phoneNumber = sms.sender;
    
//     if (phoneNumber.isEmpty) return;

//     // Check if contact already exists
//     final Iterable<Contact> existingContacts = await ContactsService.getContacts(
//       query: phoneNumber,
//     );

//     // If contact doesn't exist, create new one
//     if (existingContacts.isEmpty) {
//       final Contact newContact = Contact(
//         givenName: phoneNumber,  // Using phone number as contact name
//         phones: [Item(label: "mobile", value: phoneNumber)],
//       );

//       try {
//         await ContactsService.addContact(newContact);
//         print('New contact created for: $phoneNumber');
//       } catch (e) {
//         print('Error creating contact: $e');
//       }
//     }
//   }

//   void dispose() {
//     _smsReceiver.dispose();
//   }
// }

// // Usage example in your main app:
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final SMSContactHandler _smsHandler = SMSContactHandler();

//   @override
//   void initState() {
//     super.initState();
//     _smsHandler.initialize();
//   }

//   @override
//   void dispose() {
//     _smsHandler.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('SMS Contact Creator'),
//         ),
//         body: Center(
//           child: Text('Listening for incoming SMS...'),
//         ),
//       ),
//     );
//   }
// }