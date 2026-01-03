import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:buzzy_bee/features/notifications/presentation/widgets/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(title: 'إشعاراتك'),
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _SectionHeader(title: 'اليوم'),
                  const Divider(height: 1, color: AppColors.border),
                  const NotificationItem(
                    icon: Icons.directions_car,
                    title: 'مقدم الخدمة في طريقه إليك!',
                    message:
                        'مقدم الخدمة بدأ التوجه لموقعك، حضّر المكان وخلي الراحة تبدأ.',
                    dateTime: '10:30 AM | 31/5/2026',
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  const NotificationItem(
                    icon: Icons.check_circle_outline,
                    title: 'تم استلام طلبك بنجاح!',
                    message:
                        'فريق Buzzy Bee استلم طلبك وجاهز لتجهيزك، بيوصلك في أقرب وقت ممكن.',
                    dateTime: '09:20 AM | 31/5/2026',
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'الامس'),
                  const Divider(height: 1, color: AppColors.border),
                  const NotificationItem(
                    icon: Icons.cancel_outlined,
                    title: 'تم إلغاء الطلب بناءً على طلبك.',
                    message:
                        'فريق Buzzy Bee استلم طلب الإلغاء وتم إلغاء تجهيز الطلب بنجاح.',
                    dateTime: '10:20 PM | 30/5/2026',
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  const NotificationItem(
                    icon: Icons.local_offer_outlined,
                    title: 'لديك عرض جديد من Buzzy Bee!',
                    message:
                        'استفد من الخصومات الخاصة لفترة محدودة، ونظف بيتك بأقل الأسعار وأفضل جودة.',
                    dateTime: '01:20 PM | 30/5/2026',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'إشعاراتك',
                    style: AppTypography.headlineSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.surface,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: AppTypography.headlineSmall(
            context,
          ).copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
