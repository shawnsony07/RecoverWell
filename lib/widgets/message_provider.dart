import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final DateTime createdAt;
  final String userId;
  final String username;
  final String userImage;
  final bool isBot;

  Message({
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.isBot,
  });
}

class MessageProvider with ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => List.from(_messages);

  void addMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}
