import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:provider/provider.dart';

import 'package:ft_hangouts/pages/components/change_appbar_color.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppBarColorProvider(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactPage(),
    );
  }
}
