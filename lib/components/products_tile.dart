import 'package:comfi/components/products_tile_page.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';

class ProductsTile extends StatelessWidget {
  final Products shoe; // ← consider renaming to product later
  final VoidCallback onTap; // ← called when + is pressed
  final bool isInGrid;

  const ProductsTile({
    super.key,
    required this.shoe,
    required this.onTap,
    this.isInGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Whole tile tap → go to details
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: shoe),
          ),
        );
      },
      child: Container(
        width: isInGrid ? null : 200,
        margin: isInGrid ? null : const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                AspectRatio(
                  aspectRatio: 1.1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(shoe.imagePath, fit: BoxFit.cover),
                  ),
                ),

                // CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            shoe.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Flexible(
                          child: Text(
                            shoe.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                          ),
                        ),
                        // Spacer to push space for bottom elements
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // PRICE - bottom LEFT (now in Cedis)
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '₵${shoe.price?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // + Button - bottom RIGHT
            Positioned(
              right: 12,
              bottom: 12,
              child: GestureDetector(
                // Prevent tap from bubbling to card → details
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
