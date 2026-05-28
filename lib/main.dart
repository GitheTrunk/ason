import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './core/config/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  runApp(const AsonApp());
}
