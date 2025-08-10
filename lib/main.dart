import 'package:astro_iztro/app/bindings/initial_binding.dart';
import 'package:astro_iztro/app/routes/app_pages.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

/// [main] - Application entry point
/// Initializes the GetX app with comprehensive Purple Star Astrology features
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // [main] - Setting preferred orientations to portrait for optimal chart viewing
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // [main] - Setting system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const AstroIztroApp());
}

/// [AstroIztroApp] - Main application widget with GetX configuration
/// Implements comprehensive Purple Star Astrology app with modern UI/UX
class AstroIztroApp extends StatelessWidget {
  const AstroIztroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App configuration
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Navigation configuration
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),

      // Theme configuration - Apple Human Interface Guidelines inspired
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Localization configuration for multi-language support
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('zh', 'CN'), // Chinese Simplified
        Locale('zh', 'TW'), // Chinese Traditional
        Locale('ja', 'JP'), // Japanese
        Locale('ko', 'KR'), // Korean
        Locale('th', 'TH'), // Thai
        Locale('vi', 'VN'), // Vietnamese
      ],

      // Transition configuration for smooth navigation
      defaultTransition: Transition.cupertino,
      transitionDuration: AppConstants.mediumAnimation,

      // Enable smart management for better performance
      smartManagement: SmartManagement.keepFactory,

      // Error handling
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(
          body: Center(
            child: Text(
              'Page not found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
