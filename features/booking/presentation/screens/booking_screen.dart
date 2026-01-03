import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/features/booking/presentation/widgets/service_info_screen.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<BookingBloc>().add(const ResetBooking());
        }
      },
      child: const ServiceInfoScreen(),
    );
  }
}
