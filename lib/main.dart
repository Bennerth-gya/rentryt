import 'package:comfi/consts/app_theme.dart';
import 'package:comfi/consts/theme_controller.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
//import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 // WebViewPlatform.instance = AndroidWebViewPlatform();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ✅ Register ThemeController globally once here
  Get.put(ThemeController());

  runApp(
    ChangeNotifierProvider(
      create: (_) => Cart(),
      child: const ComfiApp(),
    ),
  );
}

class ComfiApp extends StatelessWidget {
  const ComfiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        title: 'Comfi',

        // ── Themes ──────────────────────────────────
        theme:     AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeCtrl.themeMode,  // ✅ driven by controller

        // ── Global MediaQuery override ───────────────
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context)
                  .textScaler
                  .scale(1.0)
                  .clamp(0.8, 1.15),
            ),
          ),
          child: child!,
        ),

        home: const OnboardingScreen(),
      ),
    );
  }
}