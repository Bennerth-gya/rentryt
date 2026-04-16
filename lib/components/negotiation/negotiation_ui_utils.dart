import 'package:comfi/data/models/negotiation_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMoney(double amount, {String currency = 'GHS'}) {
  return '$currency ${amount.toStringAsFixed(2)}';
}

String formatMessageTime(DateTime timestamp) {
  return DateFormat('HH:mm').format(timestamp);
}

String formatOfferExpiry(DateTime expiresAt) {
  final remaining = expiresAt.difference(DateTime.now());
  if (remaining.isNegative) {
    return 'Expired';
  }
  if (remaining.inHours >= 1) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    return 'Expires in ${hours}h ${minutes}m';
  }
  return 'Expires in ${remaining.inMinutes.clamp(1, 59)}m';
}

String offerStatusLabel(OfferStatus status) {
  switch (status) {
    case OfferStatus.pending:
      return 'Pending';
    case OfferStatus.accepted:
      return 'Accepted';
    case OfferStatus.rejected:
      return 'Rejected';
    case OfferStatus.countered:
      return 'Countered';
    case OfferStatus.expired:
      return 'Expired';
  }
}

Color offerStatusColor(OfferStatus status) {
  switch (status) {
    case OfferStatus.pending:
      return const Color(0xFFF59E0B);
    case OfferStatus.accepted:
      return const Color(0xFF10B981);
    case OfferStatus.rejected:
      return const Color(0xFFEF4444);
    case OfferStatus.countered:
      return const Color(0xFF2563EB);
    case OfferStatus.expired:
      return const Color(0xFF64748B);
  }
}

String deliveryStateLabel(MessageDeliveryState state) {
  switch (state) {
    case MessageDeliveryState.sending:
      return 'Sending';
    case MessageDeliveryState.sent:
      return 'Sent';
    case MessageDeliveryState.delivered:
      return 'Delivered';
    case MessageDeliveryState.seen:
      return 'Seen';
    case MessageDeliveryState.failed:
      return 'Failed';
  }
}

IconData deliveryStateIcon(MessageDeliveryState state) {
  switch (state) {
    case MessageDeliveryState.sending:
      return Icons.schedule_rounded;
    case MessageDeliveryState.sent:
      return Icons.check_rounded;
    case MessageDeliveryState.delivered:
      return Icons.done_all_rounded;
    case MessageDeliveryState.seen:
      return Icons.done_all_rounded;
    case MessageDeliveryState.failed:
      return Icons.error_outline_rounded;
  }
}
