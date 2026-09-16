import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/widgets/grade_card.dart';
import 'package:myapp/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('ar');
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Color(0xFF3DDC84);
    
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        final TextTheme appTextTheme = TextTheme(
          displayLarge: GoogleFonts.amiri(
            fontSize: 57, 
            fontWeight: FontWeight.bold,
            textStyle: const TextStyle(fontFamilyFallback: ['sans-serif', 'Arial']),
          ),
          titleLarge: GoogleFonts.cairo(
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            textStyle: const TextStyle(fontFamilyFallback: ['sans-serif', 'Arial']),
          ),
          bodyMedium: GoogleFonts.lato(
            fontSize: 16,
            textStyle: const TextStyle(fontFamilyFallback: ['sans-serif', 'Arial']),
          ),
        );

        return MaterialApp(
          title: 'Islamic Education',
          theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.light), textTheme: appTextTheme),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.dark), textTheme: appTextTheme),
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    int crossAxisCount;
    if (shortestSide >= 900) {
      crossAxisCount = 4; // TV
    } else if (shortestSide >= 600) {
      crossAxisCount = 3; // Tablet
    } else {
      crossAxisCount = 2; // Mobile
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).islamicBookAndSoundApp),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          Switch(
            value: localeProvider.locale.languageCode == 'ar',
            onChanged: (value) => localeProvider.setLocale(value ? const Locale('ar') : const Locale('en')),
            activeTrackColor: Colors.green.shade200,
            activeColor: Colors.white,
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Center(child: Text("AR/EN", style: TextStyle(fontWeight: FontWeight.bold)))),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeProvider.themeMode == ThemeMode.light 
              ? [const Color(0xFFE8F5E9), Colors.white] 
              : [const Color(0xFF1B5E20).withAlpha(100), const Color(0xFF121212)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(24.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24.0,
                      mainAxisSpacing: 24.0,
                      childAspectRatio: width < 600 ? 1.0 : 1.1,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => GradeCard(grade: index + 1),
                  ),
                ),
              ),
            ),
            // ✅ Wrapped in SafeArea to prevent overlap with the system navigation bar
            SafeArea(
              top: false, 
              child: _BottomCredits()
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCredits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12), // 👈 Extra bottom padding
      color: Colors.black.withAlpha(20),
      child: Column(
        children: [
          Text(isArabic ? "فكرة وإعداد وتصميم ومراجعة" : "Idea, Preparation, Design, and Review", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(isArabic ? "أساتذة مدرسة الزقورة الابتدائية المختلطة / الرصافة الأولى" : "Teachers of Al-Zaqura Mixed Primary School / Rusafa 1", style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(isArabic ? "أ. مصطفى محمد  -  أ. يوسف أياد  -  د. أحمد حيدر" : "Mr. Mustafa Mohammed - Mr. Yusuf Ayad - Dr. Ahmed Haider", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
