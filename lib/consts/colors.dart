// ────────────────────────────────────────────────────────────────────────────
// BRAND PALETTE — Comfi v2
// ────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

const Color kAccent    = Color(0xFFF0A500);   // warm gold
const Color kHighlight = Color(0xFF00C6A7);   // emerald teal
const Color kViolet    = Color(0xFF5B6EF5);   // indigo blue

// Dark palette
const Color kDarkBg      = Color(0xFF0A0E1A);
const Color kDarkSurface = Color(0xFF111827);
const Color kDarkCard    = Color(0xFF1C2537);
const Color kDarkNavy    = Color(0xFF1A2340);
const Color kDarkChip    = Color(0xFF232E45);

// Light palette
const Color kLightBg      = Color(0xFFF0F4FF);
const Color kLightSurface = Color(0xFFFFFFFF);
const Color kLightCard    = Color(0xFFE8EEFF);
const Color kLightChip    = Color(0xFFDDE4FF);

// Legacy (backward compatibility)
const Color background   = kDarkNavy;
const Color cardColor    = kDarkChip;
const Color accent       = kAccent;
const Color highlight    = kHighlight;
const Color textPrimary  = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFFCBD5E1);
// Product Color Map
final Map<String, Color> productColorMap = {
  'Black': Colors.black,
  'White': Colors.white,
  'Grey': Colors.grey,
  'Navy': const Color(0xFF001F3F),
  'Tan': const Color(0xFFD2B48C),
  'Red': Colors.red,
  'Burgundy': const Color(0xFF800020),
  'Emerald': const Color(0xFF046307),
  'Blue': Colors.blue,
  'Green': Colors.green,
  'Yellow': Colors.amber,
  'Purple': kViolet,
  'Orange': Colors.orange,
  'Pink': Colors.pink,
  'Brown': Colors.brown,
  'Teal': Colors.teal,
  'Charcoal': const Color(0xFF333333),
};

Color getProductColor(String? colorName) {
  if (colorName == null || colorName.trim().isEmpty) {
    return Colors.grey.shade600;
  }
  final n = colorName.trim();
  return productColorMap[n] ?? productColorMap[n.toLowerCase()] ?? Colors.grey.shade600;
}