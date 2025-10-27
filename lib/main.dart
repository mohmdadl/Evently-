import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:enevtly/core/di/injection_container.dart';
import 'package:enevtly/core/remote/local/prefs_manager.dart';
import 'package:enevtly/core/resourses/app_themes.dart';
import 'package:enevtly/features/auth/presentation/providers/auth_provider.dart';
import 'package:enevtly/features/auth/presentation/screens/login_screen.dart';
import 'package:enevtly/features/events/presentation/providers/events_provider.dart';
import 'package:enevtly/features/events/presentation/screens/create_event_screen.dart';
import 'package:enevtly/features/events/presentation/screens/home_screen.dart';
import 'package:enevtly/features/profile/presentation/screens/profile_screen.dart';
import 'package:enevtly/firebase_options.dart';
import 'package:enevtly/theme_provider.dart';
import 'package:enevtly/ui/splash/screen/splas_screen.dart';
import 'package:enevtly/ui/welcome/screen/welcome_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize dependencies
  await initializeDependencies();
  
  // Initialize preferences
  await PrefsManager.init();
  
  // Get saved language before initializing EasyLocalization
  final String savedLanguage = PrefsManager.getLanguage();
  
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      path: "assets/translations",
      supportedLocales: const [Locale("en"), Locale("ar")],
      fallbackLocale: const Locale("en"),
      startLocale: Locale(savedLanguage),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()..initTheme()),
          ChangeNotifierProvider(create: (_) => AuthProvider.create()),
          ChangeNotifierProvider(create: (_) => EventsProvider.create()),
        ],
        child: const Evently(),
      ),
    ),
  );
}

class Evently extends StatelessWidget {
  const Evently({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      //eazy localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      
      debugShowCheckedModeBanner: false,
      title: 'Evently',

      themeMode: themeProvider.themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      initialRoute: Splash.routName,
      routes: {
        Splash.routName: (context) => const Splash(),
        Welcome.routName: (context) => const Welcome(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-event': (context) => const CreateEventScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
