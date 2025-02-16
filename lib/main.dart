import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview_plus/device_preview_plus.dart';

void main() => runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactPage(),
    );
  }
}
