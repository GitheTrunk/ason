import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/app_strings.dart';
import 'settings_provider.dart';

final languageProvider = Provider<String>((ref) {
  final language =
      ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
  return language == 'kh' ? 'km' : language;
});

final stringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(languageProvider));
});
