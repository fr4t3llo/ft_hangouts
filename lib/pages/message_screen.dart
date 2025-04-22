// import 'package:flutter/material.dart';
// // import 'package:sms_advanced/sms_advanced.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SMSScreen extends StatefulWidget {
//   @override
//   _SMSScreenState createState() => _SMSScreenState();
// }

// class _SMSScreenState extends State<SMSScreen> {
//   final SmsQuery query = SmsQuery();
//   final SmsSender sender = SmsSender();
//   final TextEditingController _messageController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   List<SmsMessage> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _requestSmsPermission();
//   }

//   Future<void> _requestSmsPermission() async {
//     var status = await Permission.sms.request();
//     if (status.isGranted) {
//       _loadMessages();
//     }
//   }

//   Future<void> _loadMessages() async {
//     messages = await query.getAllSms;
//     setState(() {});
//   }

//   Future<void> _sendMessage() async {
//     if (_addressController.text.isEmpty || _messageController.text.isEmpty) {
//       return;
//     }

//     SmsMessage message = SmsMessage(
//       _addressController.text,
//       _messageController.text,
//     );

//     await sender.sendSms(message);

//     // Clear input fields
//     _messageController.clear();
//     _addressController.clear();

//     // Reload messages to show the new one
//     await _loadMessages();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SMS Messages'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: 'Contact Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 labelText: 'Message',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _sendMessage,
//             child: Text('Send Message'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return ListTile(
//                   title: Text(message.address ?? 'Unknown'),
//                   subtitle: Text(message.body ?? ''),
//                   trailing: Text(
//                     message.date?.toString() ?? '',y
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
// }
