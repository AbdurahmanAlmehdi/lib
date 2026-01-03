import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/widgets/error_view.dart';
import 'package:buzzy_bee/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:buzzy_bee/features/orders/domain/entities/order.dart';
import 'package:buzzy_bee/features/orders/presentation/widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersBloc>()..add(const OrdersLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.t.orders,
            style: AppTypography.titleLarge(context),
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state.status == OrdersStatus.loading &&
                    state.orders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == OrdersStatus.error &&
                    state.orders.isEmpty) {
                  return ErrorView(
                    errorMessage: state.errorMessage,
                    onRetry: () {
                      context.read<OrdersBloc>().add(
                        const OrdersLoadRequested(),
                      );
                    },
                  );
                }

                final filteredOrders = state.filteredOrders;

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Text(
                      context.t.noOrders,
                      style: AppTypography.bodyLarge(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<OrdersBloc>().add(const OrdersLoadRequested());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 70, bottom: 8),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () {
                          // TODO: Navigate to order details
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Positioned(top: 0, left: 0, right: 0, child: _FilterTabs()),
          ],
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppColors.surfaceVariant),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _FilterTab(
                label: context.t.all,
                filter: OrderFilter.all,
                isSelected: state.currentFilter == OrderFilter.all,
              ),
              const SizedBox(width: 12),
              _FilterTab(
                label: context.t.inProgress,
                filter: OrderFilter.inProgress,
                isSelected: state.currentFilter == OrderFilter.inProgress,
              ),
              const SizedBox(width: 12),
              _FilterTab(
                label: context.t.completed,
                filter: OrderFilter.completed,
                isSelected: state.currentFilter == OrderFilter.completed,
              ),
              const SizedBox(width: 12),
              _FilterTab(
                label: context.t.cancelled,
                filter: OrderFilter.cancelled,
                isSelected: state.currentFilter == OrderFilter.cancelled,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final OrderFilter filter;
  final bool isSelected;

  const _FilterTab({
    required this.label,
    required this.filter,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<OrdersBloc>().add(OrdersFilterChanged(filter));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium(context).copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
