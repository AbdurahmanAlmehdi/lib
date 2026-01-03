import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';

class DateSelectionScreen extends StatelessWidget {
  final String serviceId;

  const DateSelectionScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.selectDate)),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: TableCalendar<dynamic>(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 90)),
                  focusedDay: state.selectedDate ?? DateTime.now(),
                  selectedDayPredicate: (day) {
                    return isSameDay(state.selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(state.selectedDate, selectedDay)) {
                      context.read<BookingBloc>().add(SelectDate(selectedDay));
                    }
                  },
                  enabledDayPredicate: (day) {
                    return day.isAfter(
                      DateTime.now().subtract(const Duration(days: 1)),
                    );
                  },
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.saturday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: AppTypography.headlineMedium(context),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    disabledDecoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.selectedDate != null
                        ? () {
                            context.pushNamed(
                              AppRouteNames.cleanerCountSelection,
                            );
                          }
                        : null,
                    child: Text(context.t.next),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
