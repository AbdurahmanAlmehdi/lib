import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/orders/domain/entities/order.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: order.cleaner.avatarUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.person, size: 32),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.person, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.cleaner.name,
                          style: AppTypography.titleLarge(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.serviceName,
                          style: AppTypography.bodyMedium(
                            context,
                          ).copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM dd, yyyy').format(order.createdAt),
                    style: AppTypography.bodySmall(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  if (order.rating != null) ...[
                    Icon(Icons.star, size: 16, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      order.rating!.toStringAsFixed(1),
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t.price,
                    style: AppTypography.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                  ),
                  Text(
                    '${order.totalPrice.toStringAsFixed(2)} ${context.t.currency}',
                    style: AppTypography.titleMedium(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;

  const _StatusChip({required this.status});

  String _getStatusText(BuildContext context) {
    switch (status) {
      case BookingStatus.inProgress:
        return context.t.inProgress;
      case BookingStatus.completed:
        return context.t.completed;
      case BookingStatus.cancelled:
        return context.t.cancelled;
      case BookingStatus.confirmed:
        return context.t.confirmed;
      case BookingStatus.pending:
        return context.t.pending;
    }
  }

  Color get _statusColor {
    switch (status) {
      case BookingStatus.inProgress:
        return AppColors.info;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.confirmed:
        return AppColors.accent;
      case BookingStatus.pending:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _statusColor.withOpacity(0.3)),
      ),
      child: Text(
        _getStatusText(context),
        style: AppTypography.labelSmall(
          context,
        ).copyWith(color: _statusColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
