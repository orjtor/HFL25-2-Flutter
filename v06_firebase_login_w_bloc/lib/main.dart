import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:v06_firebase_login_w_bloc/app/app.dart';
import 'package:v06_firebase_login_w_bloc/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  try {
    debugPrint('Starting Firebase initialization...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully!');
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Firebase already initialized or error - continue anyway
  }

  debugPrint('Creating AuthenticationRepository...');
  final authenticationRepository = AuthenticationRepository();
  debugPrint('Waiting for first user...');
  await authenticationRepository.user.first;

  debugPrint('Running app...');
  runApp(App(authenticationRepository: authenticationRepository));
}
