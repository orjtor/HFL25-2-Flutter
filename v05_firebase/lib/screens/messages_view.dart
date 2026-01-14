import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:v05_firebase/services/analytics_service.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final messageController = TextEditingController();
  final _analytics = AnalyticsService();

  Future<void> addMessage(BuildContext context) async {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      announceToScreenReader(
        'The message was not sent since it was empty.',
        context,
      );
      return; // Förhindra att tomma meddelanden skickas
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('message').add({
      'text': text,
      'uid': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();

    announceToScreenReader(
      'The message was sent to the server: $text',
      context,
    );

    // Logga eventet
    await _analytics.logCustomEvent(
      'message_sent',
      parameters: {'message_length': text.length},
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${user.email}!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('message')
                .where('uid', isEqualTo: user.uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const Center(
                  child: Text('No messages yet. Write your first message!'),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['text'] ?? 'No Text...'),
                    subtitle: Text("From: ${data['uid']}"),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  label:
                      'Input field to write your message to send to the server',
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Write message... ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  addMessage(context);
                },
                icon: const Icon(
                  Icons.send,
                  semanticLabel: 'Send your message to the server',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void announceToScreenReader(String message, BuildContext context) {
  // Use View.of(context) to get the correct FlutterView
  final FlutterView view = View.of(context);

  SemanticsService.sendAnnouncement(
    view,
    message,
    TextDirection.ltr, // Specify the text direction
    assertiveness:
        Assertiveness.polite, // Optional: 'polite' (default) or 'assertive'
  );
}
