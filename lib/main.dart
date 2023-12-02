import 'package:flashlist/routing/app_router.dart';
import 'package:flashlist/theme/app_theme_dark.dart';
import 'package:flashlist/theme/app_theme_light.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
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
