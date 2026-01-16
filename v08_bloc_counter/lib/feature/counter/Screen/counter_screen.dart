import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v08_bloc_counter/feature/counter/Bloc/counter_bloc.dart';
import 'package:v08_bloc_counter/feature/counter/Bloc/counter_state.dart';
import 'package:v08_bloc_counter/feature/counter/Event/counter_event.dart';
import '../Cubit/counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Cubit + Bloc ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, int>(
              builder: (context, cubitCount) {
                return Column(
                  children: [
                    Text('Cubit count: $cubitCount'),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('XX UI: Cubit button tapped');
                        context.read<CounterCubit>().increment();
                      },
                      child: const Text('Increment Cubit'),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            //Bloc section
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, blocState) {
                return Column(
                  children: [
                    Text('Bloc count: ${blocState.value}'),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('XX UI: Bloc button tapped');
                        context.read<CounterBloc>().add(
                          CounterIncrementPressed(),
                        );
                      },
                      child: const Text('Increment Bloc'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
