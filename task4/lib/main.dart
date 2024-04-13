import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'layers/presentation/app_root.dart';

enum StateManagementOptions {
  bloc,
  provider,
}

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  Animate.restartOnHotReload = true;

  runApp(const ProviderScope(child: AppRoot()));
}
