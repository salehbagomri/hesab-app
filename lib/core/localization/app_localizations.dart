import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام التوطين (متعدد اللغات) للتطبيق
class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  /// الحصول على instance من السياق
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// الـ delegate الخاص بالـ localization
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// اللغات المدعومة
  static const List<Locale> supportedLocales = [
    Locale('ar'), // العربية
    Locale('en'), // English
  ];

  /// تحميل ملف الترجمة
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'assets/localization/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// الحصول على نص مترجم
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Getters للنصوص الشائعة
  String get appName => translate('appName');
  String get appSubtitle => translate('appSubtitle');

  String get home => translate('home');
  String get history => translate('history');
  String get settings => translate('settings');

  String get selectLevel => translate('selectLevel');
  String get recentOperations => translate('recentOperations');
  String get viewAll => translate('viewAll');
  String get noRecentOperations => translate('noRecentOperations');

  String get elementary => translate('elementary');
  String get middle => translate('middle');
  String get high => translate('high');

  String get elementaryLevel => translate('elementaryLevel');
  String get middleLevel => translate('middleLevel');
  String get highLevel => translate('highLevel');

  String get operationsAvailable => translate('operationsAvailable');

  // العمليات الحسابية
  String get addition => translate('addition');
  String get subtraction => translate('subtraction');
  String get multiplication => translate('multiplication');
  String get division => translate('division');
  String get fractions => translate('fractions');
  String get percentages => translate('percentages');

  String get linearEquations => translate('linearEquations');
  String get squareRoots => translate('squareRoots');
  String get powers => translate('powers');
  String get areas => translate('areas');
  String get ratios => translate('ratios');
  String get average => translate('average');

  String get quadraticEquations => translate('quadraticEquations');
  String get trigonometry => translate('trigonometry');
  String get logarithms => translate('logarithms');
  String get matrices => translate('matrices');
  String get sequences => translate('sequences');
  String get probability => translate('probability');

  String get calculate => translate('calculate');
  String get result => translate('result');
  String get explanation => translate('explanation');
  String get step => translate('step');
  String get steps => translate('steps');

  String get newOperation => translate('newOperation');
  String get saveToHistory => translate('saveToHistory');
  String get savedToHistory => translate('savedToHistory');
  String get savedSuccessfully => translate('savedSuccessfully');

  String get language => translate('language');
  String get selectLanguage => translate('selectLanguage');
  String get arabic => translate('arabic');
  String get english => translate('english');

  String get aboutApp => translate('aboutApp');
  String get version => translate('version');

  String get error => translate('error');
  String get success => translate('success');

  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get close => translate('close');

  // Time formatting
  String get ago => translate('ago');
  String get justNow => translate('justNow');
  String get minutesAgo => translate('minutesAgo');
  String get hoursAgo => translate('hoursAgo');
  String get daysAgo => translate('daysAgo');

  // History actions
  String get deleteAll => translate('deleteAll');
  String get deleteHistory => translate('deleteHistory');
  String get confirmDeleteAll => translate('confirmDeleteAll');
  String get deleted => translate('deleted');

  // Input labels
  String get lengthOrSide => translate('lengthOrSide');
  String get widthOrZero => translate('widthOrZero');
  String get coefficientA => translate('coefficientA');
  String get coefficientB => translate('coefficientB');
  String get constantC => translate('constantC');
  String get angleInDegrees => translate('angleInDegrees');
  String get numberValue => translate('numberValue');
  String get baseValue => translate('baseValue');
  String get firstTerm => translate('firstTerm');
  String get commonDifference => translate('commonDifference');
  String get numberOfTerms => translate('numberOfTerms');
  String get favorableOutcomes => translate('favorableOutcomes');
  String get totalOutcomes => translate('totalOutcomes');
  String get value1 => translate('value1');
  String get value2 => translate('value2');
  String get value3 => translate('value3');
  String get value4 => translate('value4');

  // Detail screen
  String get inputs => translate('inputs');
  String get time => translate('time');
  String get level => translate('level');

  // Error messages
  String get levelNotFound => translate('levelNotFound');
  String get errorLoadingDetails => translate('errorLoadingDetails');

  // Additional UI strings
  String get pageNotFound => translate('pageNotFound');
  String get enterANumber => translate('enterANumber');
  String get pleaseEnterNumber => translate('pleaseEnterNumber');
  String get pleaseEnterValidNumberFormat =>
      translate('pleaseEnterValidNumberFormat');
  String get detailedExplanationInfo => translate('detailedExplanationInfo');

  // Input field labels
  String get firstNumber => translate('firstNumber');
  String get secondNumber => translate('secondNumber');
  String get numerator => translate('numerator');
  String get denominator => translate('denominator');
  String get firstNumerator => translate('firstNumerator');
  String get firstDenominator => translate('firstDenominator');
  String get secondNumerator => translate('secondNumerator');
  String get secondDenominator => translate('secondDenominator');
  String get percentage => translate('percentage');
  String get base => translate('base');
  String get exponent => translate('exponent');
  String get valueA => translate('valueA');
  String get valueB => translate('valueB');

  String get developer => translate('developer');

  String get usefulTip => translate('usefulTip');
  String get copiedToClipboard => translate('copiedToClipboard');
}

/// Delegate لتحميل الترجمات
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
