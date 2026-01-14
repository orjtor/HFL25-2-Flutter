import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v05_firebase/auth/cubit/auth_cubit.dart';
import 'package:v05_firebase/services/analytics_service.dart';
import 'package:v05_firebase/screens/messages_view.dart';
import 'package:v05_firebase/screens/heros_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _analytics = AnalyticsService();
  int _selectedIndex = 0;

  static const List<Widget> _views = [MessagesView(), HerosView()];

  @override
  void initState() {
    super.initState();
    _analytics.logScreenView('home_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 161, 102, 167),
        title: Text(_selectedIndex == 0 ? 'Messages' : 'Heroes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.message), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Heroes'),
        ],
      ),
    );
  }
}
