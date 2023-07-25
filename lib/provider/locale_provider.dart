import 'package:flutter/material.dart';
import 'package:flutter_application/l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;
  // Constructor that takes an initial Locale value
  LocaleProvider(Locale? initialLocale) : _locale = initialLocale;
  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
