import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/routing/app_router.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // this removes the # from the url
  usePathUrlStrategy();

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
      margin: const EdgeInsets.all(Sizes.p4),
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
          margin: const EdgeInsets.all(Sizes.p4),
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
          margin: const EdgeInsets.all(Sizes.p4),
          color: Colors.black38,
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp.router(
        title: 'Flashlist',
        theme: theme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: goRouter,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('de'), // German
        ],
      ),
    );
  }
}
