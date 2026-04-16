import 'dart:io';

import 'package:comfi/components/negotiation/negotiation_ui_utils.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductPreviewCard extends StatelessWidget {
  const ProductPreviewCard({
    super.key,
    required this.product,
    required this.originalPrice,
    this.currentNegotiatedPrice,
    this.currency = 'GHS',
  });

  final ProductModel product;
  final double originalPrice;
  final double? currentNegotiatedPrice;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0);
    final cardColor = isDark ? const Color(0xFF111827) : Colors.white;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.68)
        : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _ProductImage(path: product.imagePath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.sellerName?.trim().isNotEmpty == true
                      ? product.sellerName!
                      : 'Comfi Seller',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PriceChip(
                      label: 'Original',
                      value: formatMoney(originalPrice, currency: currency),
                      backgroundColor: const Color(0xFFEFF6FF),
                      textColor: const Color(0xFF1D4ED8),
                    ),
                    _PriceChip(
                      label: 'Current',
                      value: currentNegotiatedPrice == null
                          ? 'No active deal'
                          : formatMoney(
                              currentNegotiatedPrice!,
                              currency: currency,
                            ),
                      backgroundColor: const Color(0xFFECFDF5),
                      textColor: const Color(0xFF047857),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final String value;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.7),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: 74,
        height: 74,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _ImageFallback(),
      );
    }

    if (path.isNotEmpty) {
      return Image.file(
        File(path),
        width: 74,
        height: 74,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _ImageFallback(),
      );
    }

    return _ImageFallback();
  }
}

class _ImageFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }
}
