import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizationsAr();
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @islamicArt.
  ///
  /// In en, this message translates to:
  /// **'Islamic Art'**
  String get islamicArt;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// No description provided for @islamicBookAndSoundApp.
  ///
  /// In en, this message translates to:
  /// **'Islamic Education'**
  String get islamicBookAndSoundApp;

  /// No description provided for @searchForABook.
  ///
  /// In en, this message translates to:
  /// **'Search for a book'**
  String get searchForABook;

  /// No description provided for @searchForASound.
  ///
  /// In en, this message translates to:
  /// **'Search for a sound'**
  String get searchForASound;

  /// The grade level
  ///
  /// In en, this message translates to:
  /// **'Grade {gradeNumber}'**
  String grade(int gradeNumber);

  /// No description provided for @islamicBooksForAllGrades.
  ///
  /// In en, this message translates to:
  /// **'Islamic books for all grades'**
  String get islamicBooksForAllGrades;

  /// No description provided for @readyToInstall.
  ///
  /// In en, this message translates to:
  /// **'Ready to Install'**
  String get readyToInstall;

  /// No description provided for @downloadingContent.
  ///
  /// In en, this message translates to:
  /// **'Downloading Surahs and Books...'**
  String get downloadingContent;

  /// No description provided for @installing.
  ///
  /// In en, this message translates to:
  /// **'Installing...'**
  String get installing;

  /// No description provided for @startDownload.
  ///
  /// In en, this message translates to:
  /// **'Start Download'**
  String get startDownload;

  /// No description provided for @downloadAll.
  ///
  /// In en, this message translates to:
  /// **'Download All'**
  String get downloadAll;

  /// No description provided for @noContentFound.
  ///
  /// In en, this message translates to:
  /// **'No content found.'**
  String get noContentFound;

  /// No description provided for @checkFiles.
  ///
  /// In en, this message translates to:
  /// **'Please ensure the download was successful.'**
  String get checkFiles;

  /// No description provided for @theBook.
  ///
  /// In en, this message translates to:
  /// **'The Book'**
  String get theBook;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @downloadBooksAndSurahs.
  ///
  /// In en, this message translates to:
  /// **'Download Books and Surahs'**
  String get downloadBooksAndSurahs;

  /// No description provided for @surah_1.
  ///
  /// In en, this message translates to:
  /// **'The Opening'**
  String get surah_1;

  /// No description provided for @surah_2.
  ///
  /// In en, this message translates to:
  /// **'The Win'**
  String get surah_2;

  /// No description provided for @surah_3.
  ///
  /// In en, this message translates to:
  /// **'Al-Masad'**
  String get surah_3;

  /// No description provided for @surah_4.
  ///
  /// In en, this message translates to:
  /// **'The Dedication'**
  String get surah_4;

  /// No description provided for @surah_5.
  ///
  /// In en, this message translates to:
  /// **'Al-Falaq'**
  String get surah_5;

  /// No description provided for @surah_6.
  ///
  /// In en, this message translates to:
  /// **'The People'**
  String get surah_6;

  /// No description provided for @surah_7.
  ///
  /// In en, this message translates to:
  /// **'Figs'**
  String get surah_7;

  /// No description provided for @surah_8.
  ///
  /// In en, this message translates to:
  /// **'The Most Merciful'**
  String get surah_8;

  /// No description provided for @surah_9.
  ///
  /// In en, this message translates to:
  /// **'Al-Sharh'**
  String get surah_9;

  /// No description provided for @surah_10.
  ///
  /// In en, this message translates to:
  /// **'The Afternoon'**
  String get surah_10;

  /// No description provided for @surah_11.
  ///
  /// In en, this message translates to:
  /// **'Leeches'**
  String get surah_11;

  /// No description provided for @surah_12.
  ///
  /// In en, this message translates to:
  /// **'The Elephant'**
  String get surah_12;

  /// No description provided for @surah_13.
  ///
  /// In en, this message translates to:
  /// **'The Al-Qadr'**
  String get surah_13;

  /// No description provided for @surah_14.
  ///
  /// In en, this message translates to:
  /// **'Al-Humaza'**
  String get surah_14;

  /// No description provided for @surah_15.
  ///
  /// In en, this message translates to:
  /// **'Quraysh'**
  String get surah_15;

  /// No description provided for @surah_16.
  ///
  /// In en, this message translates to:
  /// **'Luqman'**
  String get surah_16;

  /// No description provided for @surah_17.
  ///
  /// In en, this message translates to:
  /// **'The Most Merciful'**
  String get surah_17;

  /// No description provided for @surah_18.
  ///
  /// In en, this message translates to:
  /// **'The Star'**
  String get surah_18;

  /// No description provided for @surah_19.
  ///
  /// In en, this message translates to:
  /// **'The Human'**
  String get surah_19;

  /// No description provided for @surah_20.
  ///
  /// In en, this message translates to:
  /// **'The Sun'**
  String get surah_20;

  /// No description provided for @surah_21.
  ///
  /// In en, this message translates to:
  /// **'The Chair'**
  String get surah_21;

  /// No description provided for @surah_22.
  ///
  /// In en, this message translates to:
  /// **'The Night'**
  String get surah_22;

  /// No description provided for @surah_23.
  ///
  /// In en, this message translates to:
  /// **'Late Morning'**
  String get surah_23;

  /// No description provided for @surah_24.
  ///
  /// In en, this message translates to:
  /// **'The Earthquake'**
  String get surah_24;

  /// No description provided for @surah_25.
  ///
  /// In en, this message translates to:
  /// **'The Plate'**
  String get surah_25;

  /// No description provided for @surah_26.
  ///
  /// In en, this message translates to:
  /// **'The Property'**
  String get surah_26;

  /// No description provided for @surah_27.
  ///
  /// In en, this message translates to:
  /// **'The Pencil'**
  String get surah_27;

  /// No description provided for @surah_28.
  ///
  /// In en, this message translates to:
  /// **'The Ascents'**
  String get surah_28;

  /// No description provided for @surah_29.
  ///
  /// In en, this message translates to:
  /// **'The Highness'**
  String get surah_29;

  /// No description provided for @surah_30.
  ///
  /// In en, this message translates to:
  /// **'The Country'**
  String get surah_30;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ar':
    default:
      return AppLocalizationsAr();
  }
}
