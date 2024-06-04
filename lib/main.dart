import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'modules/user/view/views/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://smsxgianbjymesmeszsl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtc3hnaWFuYmp5bWVzbWVzenNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEyMTk5NDUsImV4cCI6MjAyNjc5NTk0NX0.7YipO7CMYqnTLVogoHs9VmrKZuBmLlDdk-2z9t2Xl2s',
    //url: 'https://fwxcwrgczapfadugjmfb.supabase.co',
    /*anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3eGN3cmdjemFwZmFkdWdqbWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzYxNDYzNzQsImV4cCI6MTk5MTcyMjM3NH0.InQYFRQ9gFi3Zcs81FwSi6fdMK6j2kMx08xsflffG8o',*/
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axol',
      home: const AuthPage(),
      theme: ThemeData(
          colorSchemeSeed: ColorPalette.primary,
          useMaterial3: false,
          dividerTheme: const DividerThemeData(thickness: 1)),
    );
  }
}
