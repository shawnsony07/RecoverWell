import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/ollama_service.dart';
import 'message_provider.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);

    // Add user message
    messageProvider.addMessage(
      Message(
        text: enteredMessage,
        createdAt: DateTime.now(),
        userId: user.uid,
        username: user.displayName ?? 'User',
        userImage: user.photoURL ?? 'assets/images/default_avatar.png',
        isBot: false,
      ),
    );

    try {
      // Get bot response
      final botResponse = await OllamaService.getChatResponse(enteredMessage);

      // Add bot message
      messageProvider.addMessage(
        Message(
          text: botResponse,
          createdAt: DateTime.now(),
          userId: 'bot',
          username: 'AI Assistant',
          userImage: 'assets/images/bot_avatar.png',
          isBot: true,
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get AI response: $error'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration:
                  const InputDecoration(labelText: 'Ask me anything...'),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            )
          else
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.send),
              onPressed: _submitMessage,
            ),
        ],
      ),
    );
  }
}
