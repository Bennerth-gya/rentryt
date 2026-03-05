import 'package:comfi/consts/colors.dart';
import 'package:flutter/material.dart';

class SellersThemeScreen extends StatelessWidget {
  const SellersThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: Text('Choose your theme')),
      body: Center(child: Text('Choose your theme')),
    );
  }
}
