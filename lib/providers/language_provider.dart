import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _locale = 'en'; // Default to English

  String get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString('locale') ?? 'en';
    notifyListeners();
  }

  Future<void> setLocale(String locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
    notifyListeners();
  }

  // Toggle between Arabic (index 0) and English (index 1)
  Future<void> toggleLanguage(int index) async {
    if (index == 0) {
      await setLocale('ar'); // Egypt icon = Arabic
    } else {
      await setLocale('en'); // USA icon = English
    }
  }
}

