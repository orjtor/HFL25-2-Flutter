import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTheme { light, dark }

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.light);

  void toggleTheme() {
    debugPrint('Toggling theme from $state');
    if (state == AppTheme.light) {
      emit(AppTheme.dark);
    } else {
      emit(AppTheme.light);
    }
    debugPrint('Toggled theme to $state');
  }
}
