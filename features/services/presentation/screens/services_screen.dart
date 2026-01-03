import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/di/app_injector.dart';
import 'package:buzzy_bee/features/services/presentation/bloc/services_bloc.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => sl<ServicesBloc>()
        ..add(const ServicesLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Services'),
        ),
        body: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state.status == ServicesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ServicesStatus.error) {
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            }

            return const Center(
              child: Text('Services Screen'),
            );
          },
        ),
      ),
    );
    
    
  }
}
