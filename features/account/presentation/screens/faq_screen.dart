import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'ماهو Buzzy Bee ؟',
      'answer':
          'تطبيق يقدم خدمات تنظيف المنازل والمكاتب بسرعة و بكفاءه عالية مع فريق محترف وموثوق',
    },
    {
      'question': 'كيف يمكنني حجز خدمة تنظيف ؟',
      'answer':
          'يمكنك حجز الخدمة بسهولة من خلال التطبيق. بتحديد نوع الخدمة والموعد والمكان وسيتم تأكيد الحجز فورا',
    },
    {
      'question': 'ماهي أنواع الخدمات المتاحة ؟',
      'bulletItems': [
        'تنظيف شامل للمنزل',
        'تنظيف المطبخ والحمامات',
        'تنظيف الأثاث والسجاد',
        'تنظيف المكاتب والمساحات التجارية',
      ],
    },
    {
      'question': 'هل يمكن اختيار موعد محدد للتنظيف ؟',
      'answer':
          'نعم يمكنك اختيار التاريخ و الوقت المناسب لك حسب جدول فريقنا المتاح',
    },
    {
      'question': 'هل يتوفر فريق متخصص لكل نوع خدمة ؟',
      'answer': 'نعم كل فريق متخصص في نوع الخدمة المطلوبة لضمان أعلى جودة',
    },
    {
      'question': 'هل يوجد ضمان على جودة الخدمة ؟',
      'answer':
          'نعم نضمن جودة خدماتنا في حالة عدم رضاك يمكنك التواصل معنا لاعادة التنظيف بدون تكلفة اضافية',
    },
    {
      'question': 'هل يجب ان ابقى في المنزل أثناء التنظيف ؟',
      'answer':
          'ليس بالضرورة يمكنك ترك المفاتيح في مكان امن او ترتيب الوصول مع فريقنا مسبقا',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: ''),
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 26),
              itemCount: _faqItems.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) => _FaqItem(item: _faqItems[index]),
            ),
          ),
        ],
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
                    context.t.frequentlyAskedQuestions,
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

class _FaqItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _FaqItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasBulletItems = item.containsKey('bulletItems');
    final answer = item['answer'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionRow(context),
          const SizedBox(height: 12),
          if (hasBulletItems)
            ..._buildBulletList(item['bulletItems'] as List<String>, context)
          else if (answer != null)
            _buildAnswer(answer, context),
        ],
      ),
    );
  }

  Widget _buildQuestionRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '?',
              style: AppTypography.bodyMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item['question'] as String,
            style: AppTypography.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBulletList(List<String> items, BuildContext context) {
    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: AppTypography.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.textSecondary),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: AppTypography.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.textSecondary, height: 1.5),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildAnswer(String answer, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Text(
        answer,
        style: AppTypography.bodyMedium(
          context,
        ).copyWith(color: AppColors.textSecondary, height: 1.5),
        textAlign: TextAlign.right,
      ),
    );
  }
}
