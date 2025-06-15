import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options_dev.dart';
import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Optional: Preload SharedPreferences if you want to do something before MyApp
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode');

  debugPrint('🌗 Saved theme on startup dev: $savedTheme');

  runApp(const ProviderScope(child: MyApp()));
}
