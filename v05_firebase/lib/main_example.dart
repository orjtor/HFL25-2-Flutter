import 'import_nest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider( // envobj
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(context.read<AuthRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase Auth with Cubit',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const AuthFlow(),
        ),
      ),
    );
  }
}

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        
        if (state is AuthAuthenticated) {
          return const HomeScreen();
        }
        if (state is AuthUnauthenticated) {
          return const LoginScreen();
        }
        return const SplashScreen();
      },
    );
  }
}


/// import_nest.dart

export 'package:auth_app/auth/cubit/auth_cubit.dart';
export 'package:auth_app/auth/cubit/auth_state.dart';
export 'package:auth_app/auth/repository/auth_repository.dart';
export 'package:auth_app/screens/home_screen.dart';
export 'package:auth_app/screens/login_screen.dart';
export 'package:auth_app/screens/splash_screen.dart';
export 'package:flutter/material.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'firebase_options.dart';