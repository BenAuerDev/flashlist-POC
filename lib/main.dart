import 'package:brainstorm_array/screens/auth.dart';
import 'package:brainstorm_array/screens/home.dart';
import 'package:brainstorm_array/screens/splash.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = retrieveTextTheme(context);

    return MaterialApp(
      title: 'Brainstorm Array',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 255, 180),
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
