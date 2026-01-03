import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/features/cleaners/presentation/bloc/cleaners_bloc.dart';

class CleanersScreen extends StatelessWidget {
  const CleanersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => sl<CleanersBloc>()
        ..add(const CleanersLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cleaners'),
        ),
        body: BlocBuilder<CleanersBloc, CleanersState>(
          builder: (context, state) {
            if (state.status == CleanersStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CleanersStatus.error) {
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            }

            return const Center(
              child: Text('Cleaners Screen'),
            );
          },
        ),
      ),
    );
    
    
  }
}
