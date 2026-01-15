import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v07_cubit/app/theme/cubit/theme_cubit.dart';
import 'package:v07_cubit/features/counter/cubit/counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$count', style: const TextStyle(fontSize: 50)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterCubit>().increment();
                    debugPrint(
                      'Incremented to ${context.read<CounterCubit>().state}',
                    ); //bara i debugläge
                    print(
                      'Incremented to ${context.read<CounterCubit>().state}',
                    ); //bara när man kör flutter run
                  },
                  child: const Text('Increment'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
