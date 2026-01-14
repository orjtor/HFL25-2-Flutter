import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:v05_firebase/services/analytics_service.dart';

class HerosView extends StatefulWidget {
  const HerosView({super.key});

  @override
  State<HerosView> createState() => _HerosViewState();
}

class _HerosViewState extends State<HerosView> {
  final _analytics = AnalyticsService();

  void _showAddHeroDialog() {
    final nameController = TextEditingController();
    final powerController = TextEditingController();
    String selectedAlignment = 'good';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Hero'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter hero name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: powerController,
                  decoration: const InputDecoration(
                    labelText: 'Power',
                    hintText: 'Enter hero power',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedAlignment,
                  decoration: const InputDecoration(
                    labelText: 'Alignment',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'good', child: Text('Good')),
                    DropdownMenuItem(value: 'bad', child: Text('Bad')),
                    DropdownMenuItem(value: 'neutral', child: Text('Neutral')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedAlignment = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final power = powerController.text.trim();

              if (name.isEmpty || power.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              await FirebaseFirestore.instance.collection('heros').add({
                'name': name,
                'power': power,
                'alignment': selectedAlignment,
              });

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name added successfully!')),
                );
                // Logga eventet
                await _analytics.logCustomEvent(
                  'hero_created',
                  parameters: {
                    'hero_name': name,
                    'alignment': selectedAlignment,
                  },
                );
              }
            },
            child: const Text('Add Hero'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('heros').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No heroes yet. Add some heroes to your collection!'),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(data['name']?[0] ?? 'H')),
                  title: Text(data['name'] ?? 'Unknown Hero'),
                  subtitle: Text(
                    '${data['power'] ?? 'No power'} • ${data['alignment'] ?? 'unknown'}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('heros')
                          .doc(docs[index].id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHeroDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
