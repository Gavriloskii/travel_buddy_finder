class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  // TODO: Add fromJson and toJson methods for API integration
}

class Conversation {
  final String id;
  final String userId; // The other user's ID
  final String userName;
  final String userProfilePic;
  final Message lastMessage;

  Conversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.lastMessage,
  });

  // TODO: Add fromJson and toJson methods for API integration
}
