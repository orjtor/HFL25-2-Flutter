import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v07_cubit/app/theme/cubit/theme_cubit.dart';
import 'package:v07_cubit/features/counter/cubit/counter_cubit.dart';
import 'package:v07_cubit/features/counter/cubit/counter_state.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter View - Labb 1'),
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
        child: BlocBuilder<CounterCubit, CounterState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Visa error om det finns något
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Visa count eller loading indicator
                if (state.isLoading)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading...', style: TextStyle(fontSize: 20)),
                    ],
                  )
                else
                  Text(
                    '${state.count}',
                    style: const TextStyle(fontSize: 50),
                  ),

                const SizedBox(height: 32),

                // Synkron increment
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<CounterCubit>().increment();
                          debugPrint('Synkron increment: ${state.count + 1}');
                        },
                  child: const Text('Increment (direkt)'),
                ),

                const SizedBox(height: 16),

                // Async increment med 2 sek delay
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<CounterCubit>().incrementAsync();
                          debugPrint('Startar async increment...');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Increment Async (2 sek)'),
                ),

                const SizedBox(height: 16),

                // Decrement knapp
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<CounterCubit>().decrement();
                        },
                  child: const Text('Decrement'),
                ),

                const SizedBox(height: 16),

                // Reset knapp
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<CounterCubit>().reset();
                        },
                  child: const Text('Reset'),
                ),

                const SizedBox(height: 32),

                // Debug info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'State Info:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('isLoading: ${state.isLoading}'),
                      Text('count: ${state.count}'),
                      Text('error: ${state.error ?? "none"}'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
