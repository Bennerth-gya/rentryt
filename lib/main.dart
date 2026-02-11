import 'package:comfi/models/cart.dart';
import 'package:comfi/pages/categories_screen.dart';
import 'package:comfi/pages/home_page.dart';
import 'package:comfi/pages/intro_page.dart';
import 'package:comfi/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      // Add this:
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: OverflowBox(
          // helps visualize
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
      home: ChangeNotifierProvider(
        create: (context) => Cart(),
        builder: (context, child) => const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: IntroPage(),
        ),
      ),
    );
  }
}
