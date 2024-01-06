import 'package:flutter/material.dart';
import 'package:supabase_demo/config/app.dart';
import 'package:supabase_demo/services/database_service/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.instance.initialize();

  runApp(const App());
}
