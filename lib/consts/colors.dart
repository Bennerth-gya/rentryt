import 'package:flutter/material.dart';

// ────────────────────────────────────────────────
//          App-wide theme / background colors
// ────────────────────────────────────────────────
const Color background = Color(0xFF1E2A4A);
const Color cardColor = Color(0xFF252F5C);
const Color accent = Color(0xFFFFC843);
const Color highlight = Color(0xFFE83A8A);
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFFCFCFD6);

// ────────────────────────────────────────────────
//     Product color name → Flutter Color mapping
// ────────────────────────────────────────────────
// This map is used to convert strings like "Black", "Tan", "Burgundy"
// (coming from your Products.colors list) into actual Color objects.

final Map<String, Color> productColorMap = {
  // Common colors from your current products
  'Black': Colors.black,
  'White': Colors.white,
  'Grey': ?Colors.grey[170], // or Colors.grey
  'Navy': const Color(0xFF001F3F), // deep navy
  'Tan': const Color(0xFFD2B48C),
  'Red': Colors.red,
  'Burgundy': const Color(0xFF800020),
  'Emerald': const Color(0xFF046307),

  // Additional useful colors (you can remove ones you don't need)
  'Blue': Colors.blue,
  'Green': Colors.green,
  'Yellow': Colors.amber,
  'Purple': const Color(0xFF8B5CF6), // matches your earlier accent/purple
  'Orange': Colors.orange,
  'Pink': Colors.pink,
  'Brown': Colors.brown,
  'Teal': Colors.teal,

  // Variants / shades (optional – good for better UX)
  'Charcoal': const Color(0xFF333333),
};

// Helper function – safe way to get a color from a name
// Returns grey as fallback if name is not found
Color getProductColor(String? colorName) {
  if (colorName == null || colorName.trim().isEmpty) {
    return Colors.grey.shade600;
  }

  final normalized = colorName.trim();

  return productColorMap[normalized] ??
      productColorMap[normalized.toLowerCase()] ?? // try lowercase too
      Colors.grey.shade600; // safe fallback
}
