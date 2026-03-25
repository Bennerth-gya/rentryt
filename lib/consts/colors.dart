import 'package:flutter/material.dart';

// ────────────────────────────────────────────────────────────────────────────
// BRAND PALETTE
// ────────────────────────────────────────────────────────────────────────────
const Color kAccent = Color(0xFFFFC843);      // golden yellow
const Color kHighlight = Color(0xFFE83A8A);   // hot pink
const Color kViolet = Color(0xFF8B5CF6);      // main purple

// Dark palette
const Color kDarkBg = Color(0xFF080C14);
const Color kDarkSurface = Color(0xFF111827);
const Color kDarkCard = Color(0xFF1F2937);
const Color kDarkNavy = Color(0xFF1E2A4A);
const Color kDarkChip = Color(0xFF252F5C);

// Light palette
const Color kLightBg = Color(0xFFF5F7FF);
const Color kLightSurface = Color(0xFFFFFFFF);
const Color kLightCard = Color(0xFFEEF1FB);
const Color kLightChip = Color(0xFFE2E8F8);

// Legacy (for backward compatibility)
const Color background = kDarkNavy;
const Color cardColor = kDarkChip;
const Color accent = kAccent;
const Color highlight = kHighlight;
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFFCFCFD6);

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