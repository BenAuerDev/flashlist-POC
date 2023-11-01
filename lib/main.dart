import 'package:flash_list/providers/users.dart';
import 'package:flash_list/screens/auth.dart';
import 'package:flash_list/screens/home.dart';
import 'package:flash_list/screens/splash.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp(savedThemeMode: savedThemeMode)));
}

class MyApp extends ConsumerWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = retrieveTextTheme(context);

    final cardTheme = const CardTheme().copyWith(
      margin: const EdgeInsets.all(4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    );

    return AdaptiveTheme(
      light: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          textTheme.apply(bodyColor: Colors.black),
        ),
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        cardTheme: cardTheme.copyWith(
          margin: const EdgeInsets.all(4),
        ),
      ),
      dark: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          textTheme.apply(bodyColor: Colors.white),
        ),
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        cardTheme: cardTheme.copyWith(
          margin: const EdgeInsets.all(4),
          color: Colors.black38,
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Flashlist',
        theme: theme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: DefaultTabController(
          length: 2,
          child: ref.watch(authProvider).when(
                loading: () => const SplashScreen(),
                error: (error, stackTrace) {
                  return const Center(child: Text('Error loading user'));
                },
                data: (user) {
                  if (user != null) {
                    return const HomeScreen();
                  }
                  return const AuthScreen();
                },
              ),
        ),
      ),
    );
  }
}
