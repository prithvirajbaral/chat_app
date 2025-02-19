import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: false,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        final loadedMessage = chatSnapshot.data!.docs;

        return ListView.builder(
          itemCount: loadedMessage.length,
          itemBuilder: (ctx, index) => Text(
            loadedMessage[index].data()['text'],
          ),
        );
      },
    );
  }
}
