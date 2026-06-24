import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'en',
    this.bloodGroup,
    this.allergies,
  });

  final ThemeMode themeMode;
  final String language;
  final String? bloodGroup;
  final String? allergies;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    String? bloodGroup,
    String? allergies,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _themeKey = 'theme_mode';
  static const _langKey = 'language';
  static const _bloodGroupKey = 'blood_group';
  static const _allergiesKey = 'allergies';

  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      themeMode:
          ThemeMode.values[prefs.getInt(_themeKey) ?? ThemeMode.system.index],
      language: _normalizeLanguage(prefs.getString(_langKey) ?? 'en'),
      bloodGroup: prefs.getString(_bloodGroupKey),
      allergies: prefs.getString(_allergiesKey),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    state = AsyncData(state.requireValue.copyWith(themeMode: mode));
  }

  Future<void> setLanguage(String lang) async {
    final normalizedLang = _normalizeLanguage(lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, normalizedLang);
    state = AsyncData(state.requireValue.copyWith(language: normalizedLang));
  }

  Future<void> saveMedicalInfo({String? bloodGroup, String? allergies}) async {
    final prefs = await SharedPreferences.getInstance();
    if (bloodGroup != null) await prefs.setString(_bloodGroupKey, bloodGroup);
    if (allergies != null) await prefs.setString(_allergiesKey, allergies);
    state = AsyncData(
      state.requireValue.copyWith(bloodGroup: bloodGroup, allergies: allergies),
    );
  }
}

String _normalizeLanguage(String lang) => lang == 'kh' ? 'km' : lang;

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
