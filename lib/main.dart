import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toastification/toastification.dart';

import 'app_router.dart';
import 'utils/anchor_rive_utils.dart';
import 'utils/app_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('en');
  await initializeDateFormatting('ko');
  await AppPrefs.init();
  await AnchorPreloader.instance.preloadAllAnchors();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(routerConfig: appRouter, title: 'AInchor News'),
    );
  }
}
