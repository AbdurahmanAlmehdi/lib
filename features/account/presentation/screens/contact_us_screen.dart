import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: ''),
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _ContactItem(
                  title: 'رقم الهاتف :',
                  icon: Icons.call,

                  content: '0925443434 - 0912323245',
                ),
                const Divider(
                  color: Color.fromARGB(255, 211, 209, 209),
                  height: 1,
                ),
                _ContactItem(
                  title: 'البريد الالكتروني :',
                  icon: Icons.email,
                  content: 'buzzyBee@gmail.com',
                ),
                const Divider(color: AppColors.border, height: 1),
                _ContactItem(
                  title: 'ساعات العمل :',
                  icon: Icons.schedule,
                  content: 'كل الايام من 9 صباحا الى 2 مساءً',
                ),
                const Divider(color: AppColors.border, height: 1),
                _SocialMediaSection(),
                const Divider(color: AppColors.border, height: 1),
                _ClosingMessage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _ContactItem({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: const Color.fromRGBO(92, 99, 114, 100),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.bodyLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(92, 99, 114, 100),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              content,
              style: AppTypography.bodyMedium(
                context,
              ).copyWith(color: AppColors.textSecondary, height: 1.5),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialMediaSection extends StatelessWidget {
  static final List<Map<String, String>> _socialMedia = [
    {'name': 'فيسبوك :', 'url': 'https://www.facebook.com/BuzzyBeeCleaning'},
    {'name': 'انستغرام :', 'url': 'https://www.instagram.com/BuzzyBeeCleaning'},
    {'name': 'اكس :', 'url': 'https://x.com/BuzzyBeeCleaning'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people,
                  size: 16,
                  color: const Color.fromRGBO(92, 99, 114, 100),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'روابط التواصل الاجتماعي :',
                style: AppTypography.bodyLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(92, 99, 114, 100),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._socialMedia.map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 40, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']!,
                    style: AppTypography.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.textSecondary, height: 1.5),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    item['url']!,
                    style: AppTypography.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.textSecondary, height: 1.5),
                    textAlign: TextAlign.right,
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

class _ClosingMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
      child: Column(
        children: [
          Text(
            'نحن هنا لمساعدتك في اي وقت !',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'لا تتردد في التواصل معنا',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
