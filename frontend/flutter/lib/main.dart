import 'package:agro_millets/core/admin/presentation/admin_page.dart';
import 'package:agro_millets/core/auth/presentation/login_page.dart';
import 'package:agro_millets/core/home/presentation/home_page.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:khalti/khalti.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Khalti.init(
    publicKey: 'test_public_key_0c8c371933c447498a9c3a172c68e344',
    enabledDebugging: true,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.debug,
  );
  await EasyLocalization.ensureInitialized();
  await appCache.getDataFromDevice();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('hi')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AIMS",
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: getHomePage(),
    );
  }

  getHomePage() {
    if (!appState.value.isLoggedIn) {
      return const LoginPage();
    }
    return const RolePage();
  }
}

// Only takes part during startup
class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return appState.value.user!.userType == "admin"
        ? const AdminPage()
        : const HomePage();
  }

}
