// ignore_for_file: depend_on_referenced_packages, unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:ft_hangouts/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppBarColorProvider(),
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [Locale('en'), Locale('es')],
        fallbackLocale: Locale('en '),
        assetLoader: CodegenLoader(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactPage(),
    );
  }
}
