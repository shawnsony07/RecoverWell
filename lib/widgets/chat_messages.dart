import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'message_provider.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final messages = Provider.of<MessageProvider>(context).messages;

    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet - start a conversation!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: 40,
        left: 13,
        right: 13,
      ),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (ctx, index) {
        final currentMessage = messages[index];
        final nextMessage =
            index + 1 < messages.length ? messages[index + 1] : null;

        final currentMessageUserId = currentMessage.userId;
        final nextMessageUserId = nextMessage?.userId;
        final nextUserIsSame = nextMessageUserId == currentMessageUserId;

        if (nextUserIsSame) {
          return MessageBubble.next(
            message: currentMessage.text,
            isMe: authenticatedUser.uid == currentMessageUserId,
          );
        } else {
          return MessageBubble.first(
            userImage: currentMessage.userImage,
            username: currentMessage.username,
            message: currentMessage.text,
            isMe: authenticatedUser.uid == currentMessageUserId,
          );
        }
      },
    );
  }
}
