import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v07_cubit/app/theme/app_theme.dart';
import 'package:v07_cubit/app/theme/cubit/theme_cubit.dart';
import 'package:v07_cubit/features/counter/cubit/counter_cubit.dart';
import 'package:v07_cubit/features/counter/screens/counter_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => CounterCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Cubit Test App',
          theme: state == AppTheme.light ? AppThemes.light : AppThemes.dark,
          home: const CounterScreen(),
        );
      },
    );
  }
}
