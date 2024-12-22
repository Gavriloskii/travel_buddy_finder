import 'package:flutter/foundation.dart';
import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void addMessage(Message message) {
    _messages.add(message);
    if (!message.isRead) {
      _unreadCount++;
      notifyListeners();
    }
  }

  void addSystemMessage(String content, String receiverId) {
    final systemMessage = Message(
      id: 'system_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
      isRead: true,
    );
    addMessage(systemMessage);
  }

  void markMessageAsRead(String messageId) {
    final messageIndex = _messages.indexWhere((m) => m.id == messageId);
    if (messageIndex != -1 && !_messages[messageIndex].isRead) {
      final message = _messages[messageIndex];
      _messages[messageIndex] = Message(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timestamp: message.timestamp,
        isRead: true,
      );
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
    }
  }

  void markAllMessagesAsRead() {
    bool hasUnreadMessages = false;
    for (int i = 0; i < _messages.length; i++) {
      if (!_messages[i].isRead) {
        final message = _messages[i];
        _messages[i] = Message(
          id: message.id,
          senderId: message.senderId,
          receiverId: message.receiverId,
          content: message.content,
          timestamp: message.timestamp,
          isRead: true,
        );
        hasUnreadMessages = true;
      }
    }
    if (hasUnreadMessages) {
      _unreadCount = 0;
      notifyListeners();
    }
  }
}
