import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return RootNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileView(),
          ),
          GoRoute(
            path: '/details/:id',
            name: 'details',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'unknown';
              return DetailView(id: id);
            },
          ),
          GoRoute(
            path: '/details',
            name: 'details-empty',
            builder: (context, state) {
              return const DetailView(id: 'unknown');
            },
          ),
        ],
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class RootNavigation extends StatelessWidget {
  final Widget child;
  const RootNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/profile')) {
      currentIndex = 1;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
              break;
            case 1:
              context.goNamed('profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home, size: 100, color: Colors.deepPurple),
          const SizedBox(height: 20),
          Text('Home View', style: Theme.of(context).textTheme.headlineMedium),
          ElevatedButton(
            onPressed: () {
              context.push('/details/42');
            },
            child: Text('Goto Details for item 42'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/details/43');
            },
            child: Text('Goto Details for item 43'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/details/');
            },
            child: Text('Goto Details for null item'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/details');
            },
            child: Text('Goto Details for no item'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/details/unknown');
            },
            child: Text('Goto Details for unknown item'),
          ),
        ],
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 100, color: Colors.deepPurple),
          const SizedBox(height: 20),
          Text(
            'Profile View',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final String id;
  const DetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Kontrollera om id saknas eller är ogiltigt
    final bool isValidId = id != 'unknown' && id.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(isValidId ? "Detail View $id" : "Detail View - Error"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isValidId ? Icons.details : Icons.error_outline,
              size: 100,
              color: isValidId ? Colors.deepPurple : Colors.red,
            ),
            const SizedBox(height: 20),
            if (isValidId)
              Text(
                'Details for item: $id',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            else ...[
              Text(
                'ID saknas',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 10),
              Text(
                'Kunde inte hitta detaljer utan ett giltigt ID',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Tillbaka till Home'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
