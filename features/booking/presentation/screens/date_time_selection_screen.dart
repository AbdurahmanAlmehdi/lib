import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';

class DateTimeSelectionScreen extends StatefulWidget {
  const DateTimeSelectionScreen({super.key});

  @override
  State<DateTimeSelectionScreen> createState() =>
      _DateTimeSelectionScreenState();
}

class _DateTimeSelectionScreenState extends State<DateTimeSelectionScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  final List<String> _timeSlots = [
    '9:00 صباحًا',
    '10:00 صباحًا',
    '11:00 صباحًا',
    '12:00 صباحًا',
    '1:00 مساءً',
    '2:00 مساءً',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<BookingBloc>().state;
    _selectedDay = state.selectedDate;
    _selectedTime = state.selectedTime;
    if (_selectedDay != null) {
      _focusedDay = _selectedDay!;
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    context.read<BookingBloc>().add(SelectDate(selectedDay));
  }

  void _onTimeSelected(String time) {
    setState(() {
      _selectedTime = time;
    });
    context.read<BookingBloc>().add(SelectTime(time));
  }

  void _onContinue() {
    if (_selectedDay != null && _selectedTime != null) {
      context.pushNamed(AppRouteNames.cleanerCountSelection);
    } else {
      context.showSnackBar(context.t.pleaseSelectDateAndTime);
    }
  }

  String _getSelectedSummary() {
    if (_selectedDay == null || _selectedTime == null) {
      return '';
    }
    final monthName = _getMonthName(_selectedDay!.month);
    return 'التاريخ التي تم اختياره ${_selectedDay!.day} من $monthName, الوقت $_selectedTime';
  }

  String _getMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(title: context.t.step1),
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        context.t.selectServiceDate,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Calendar
                      Flexible(
                        flex: 2,
                        child: _CalendarWidget(
                          focusedDay: _focusedDay,
                          selectedDay: _selectedDay,
                          onDaySelected: _onDaySelected,
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Time selection title
                      Text(
                        context.t.selectTime,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Time slots
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: _timeSlots.map((time) {
                          final isSelected = _selectedTime == time;
                          return _TimeSlotButton(
                            time: time,
                            isSelected: isSelected,
                            onTap: () => _onTimeSelected(time),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      // Summary
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 8),
                      Flexible(
                        flex: 0,
                        child: Text(
                          _selectedDay != null && _selectedTime != null
                              ? _getSelectedSummary()
                              : context.t.pleaseSelectDateAndTime,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium(
                            context,
                          ).copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Continue button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.info,
                              foregroundColor: AppColors.textOnSecondary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _onContinue,
                            child: Text(
                              context.t.continueText,
                              style: AppTypography.titleLarge(context).copyWith(
                                color: AppColors.textOnSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const _CalendarWidget({
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.info,
            size: 20,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.info,
            size: 20,
          ),
          titleTextStyle: AppTypography.titleLarge(
            context,
          ).copyWith(color: AppColors.textPrimary),
          leftChevronPadding: EdgeInsets.zero,
          rightChevronPadding: EdgeInsets.zero,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.info,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: AppTypography.bodyMedium(context),
          weekendTextStyle: AppTypography.bodyMedium(context),
          selectedTextStyle: AppTypography.bodyMedium(
            context,
          ).copyWith(color: AppColors.textOnSecondary),
          cellAlignment: Alignment.center,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTypography.bodySmall(
            context,
          ).copyWith(color: AppColors.textSecondary),
          weekendStyle: AppTypography.bodySmall(
            context,
          ).copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _TimeSlotButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeSlotButton({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.info : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.info : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            time,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium(context).copyWith(
              color: isSelected
                  ? AppColors.textOnSecondary
                  : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
