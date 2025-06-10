import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:litewritten/firebase_options.dart';
import 'package:litewritten/screens/loginScreen.dart';
import 'package:litewritten/screens/registrationScreen.dart';
import 'package:litewritten/screens/uploadAudio(do%20not%20touch).dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(LitewrittenApp());
}

class LitewrittenApp extends StatelessWidget {
  const LitewrittenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
