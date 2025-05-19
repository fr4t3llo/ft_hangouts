import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ft_hangouts/pages/background_timer.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'package:ft_hangouts/pages/components/message_provider.dart';
import 'package:ft_hangouts/pages/contact_page.dart';
import 'package:ft_hangouts/providers/app_lifecycle_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppBarColorProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => AppLifecycleProvider()),
      ],
      child: LifecycleManager(
        child: MaterialApp(
          title: 'FT Hangouts',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'my',
          ),
          home: const ContactPage(),
        ),
      ),
    );
  }
}

class LifecycleManager extends StatefulWidget {
  final Widget child;

  const LifecycleManager({super.key, required this.child});

  @override
  State<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lifecycleProvider = context.read<AppLifecycleProvider>();
    
    switch (state) {
      case AppLifecycleState.paused:
        lifecycleProvider.onAppBackground();
        break;
      case AppLifecycleState.resumed:
        lifecycleProvider.onAppForeground();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
