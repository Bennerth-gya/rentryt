import 'package:comfi/components/negotiation/negotiation_ui_utils.dart';
import 'package:comfi/data/models/negotiation_models.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.isMine,
    required this.isLatest,
    this.showActions = false,
    this.showCounterAction = false,
    this.isBusy = false,
    this.onAccept,
    this.onReject,
    this.onCounter,
  });

  final NegotiationOfferModel offer;
  final bool isMine;
  final bool isLatest;
  final bool showActions;
  final bool showCounterAction;
  final bool isBusy;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCounter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = offerStatusColor(offer.status);
    final cardColor = isMine
        ? const Color(0xFFDCF7E3)
        : isDark
        ? const Color(0xFF132031)
        : const Color(0xFFF8FAFC);
    final borderColor = isLatest
        ? accent.withValues(alpha: 0.55)
        : isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);

    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isLatest ? 1.6 : 1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isLatest ? 0.14 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  offerStatusLabel(offer.status),
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              if (isLatest)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF111827,
                    ).withValues(alpha: isDark ? 0.45 : 0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Latest offer',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formatMoney(offer.offeredPrice, currency: offer.currency),
            style: TextStyle(
              color: primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            offer.isCounterOffer
                ? 'Counter-offer from the seller'
                : isMine
                ? 'Your offer is awaiting a response'
                : 'Respond to this offer to continue checkout',
            style: TextStyle(
              color: secondaryText,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 14, color: secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  offer.status == OfferStatus.pending
                      ? formatOfferExpiry(offer.expiresAt)
                      : 'Updated ${formatMessageTime(offer.respondedAt ?? offer.createdAt)}',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isBusy ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: isBusy ? null : onAccept,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
            if (showCounterAction) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: isBusy ? null : onCounter,
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text('Counter Offer'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
