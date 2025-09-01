import 'package:astro_iztro/app/bindings/initial_binding.dart';
import 'package:astro_iztro/app/routes/app_pages.dart';
import 'package:astro_iztro/app/routes/app_routes.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
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

  // Initialize StorageService synchronously
  final storageService = StorageService();
  await storageService.initialize();
  Get
    ..put<StorageService>(storageService, permanent: true)
    // Initialize IztroService
    ..put<IztroService>(IztroService(), permanent: true);

  // Check if onboarding has been completed
  final onboardingCompleted =
      storageService.prefs.getBool(
        AppConstants.onboardingCompletedKey,
      ) ??
      false;

  // Set initial route based on onboarding status
  final initialRoute = onboardingCompleted
      ? AppRoutes.home
      : AppRoutes.onboarding;

  // [main] - Setting preferred orientations to portrait for optimal chart viewing
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // [main] - Setting system UI overlay style for immersive full-screen experience
  // Following Apple Human Interface Guidelines for seamless, edge-to-edge design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Make status bar transparent for full-screen experience
      statusBarColor: Colors.transparent,
      // Use light content for dark backgrounds, dark for light backgrounds
      statusBarIconBrightness:
          Brightness.light, // White icons for gradient background
      statusBarBrightness: Brightness.dark, // For iOS
      // Make navigation bar transparent and edge-to-edge
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      // Enable edge-to-edge content
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // [main] - Enable edge-to-edge mode for modern full-screen experience
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  runApp(AstroIztroApp(initialRoute: initialRoute));
}

/// [AstroIztroApp] - Main application widget with GetX configuration
/// Implements comprehensive Purple Star Astrology app with modern UI/UX
class AstroIztroApp extends StatelessWidget {
  const AstroIztroApp({
    required this.initialRoute,
    super.key,
  });
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App configuration
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Navigation configuration
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),

      // Theme configuration - Apple Human Interface Guidelines inspired
      theme: AppTheme.darkTheme, // Use dark theme as default
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
