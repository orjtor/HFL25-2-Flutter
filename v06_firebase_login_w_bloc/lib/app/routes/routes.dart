import 'package:flutter/widgets.dart';
import 'package:v06_firebase_login_w_bloc/app/app.dart';
import 'package:v06_firebase_login_w_bloc/home/home.dart';
import 'package:v06_firebase_login_w_bloc/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
