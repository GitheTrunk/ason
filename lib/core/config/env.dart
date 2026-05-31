import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  const Env._();

  static String get supabaseUrl => _requiredValue('SUPABASE_URL');

  static String get supabaseAnonKey => _requiredValue('SUPABASE_ANON_KEY');

  static String _requiredValue(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }
}
