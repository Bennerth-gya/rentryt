import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/shoe.dart';
import 'package:flutter/material.dart';

class ShoeTile extends StatelessWidget {
  final Shoe shoe;
  final VoidCallback onTap;
  final bool isInGrid;

  const ShoeTile({
    super.key,
    required this.shoe,
    required this.onTap,
    this.isInGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isInGrid ? null : 200,
      margin: isInGrid ? null : const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          AspectRatio(
            aspectRatio: 1.1,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(shoe.imagePath, fit: BoxFit.cover),
            ),
          ),

          /// CONTENT (EXPANDS SAFELY)
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
                      shoe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: textSecondary),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add", style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
