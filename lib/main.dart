// main.dart
import 'package:duka_app/pages/login.dart';
import 'package:duka_app/onboarding/onboarding_screen.dart';
import 'package:duka_app/l10n/app_localizations.dart';
import 'package:duka_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API service
  final apiService = ApiService();
  apiService.init();
  await apiService.loadToken();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<Locale> _localeNotifier = ValueNotifier(
    const Locale('en'),
  );

  @override
  void dispose() {
    _localeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLocale(
      notifier: _localeNotifier,
      child: ValueListenableBuilder<Locale>(
        valueListenable: _localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('sw')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const OnboardingScreen(),
            routes: {
              '/home': (context) => LoginPage(),
            },
          );
        },
      ),
    );
  }
}

class AppLocale extends InheritedNotifier<ValueNotifier<Locale>> {
  const AppLocale({
    super.key,
    required ValueNotifier<Locale> notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static Locale of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<AppLocale>();
    return inherited?.notifier?.value ?? const Locale('en');
  }

  static void setLocale(BuildContext context, Locale locale) {
    final inherited = context.dependOnInheritedWidgetOfExactType<AppLocale>();
    inherited?.notifier?.value = locale;
  }
}
