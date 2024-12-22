import 'package:travel_buddy_finder/models/user_profile.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  // Create an empty welcome message for new matches
  static Message createWelcomeMessage(String senderId, String receiverId, UserProfile matchedUser) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'system',
      receiverId: receiverId,
      content: "You matched with ${matchedUser.name}! Start your conversation now.",
      timestamp: DateTime.now(),
    );
  }
}

class Conversation {
  final String id;
  final String userId; // The other user's ID
  final String userName;
  final String userProfilePic;
  final Message lastMessage;
  final List<Message> messages; // Added to store conversation history

  Conversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.lastMessage,
    this.messages = const [], // Default to empty list
  });

  // Create a new conversation from a match
  static Conversation createFromMatch({
    required UserProfile matchedUser,
    required String currentUserId,
  }) {
    final welcomeMessage = Message.createWelcomeMessage(
      currentUserId,
      matchedUser.id,
      matchedUser,
    );

    return Conversation(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      userId: matchedUser.id,
      userName: matchedUser.name,
      userProfilePic: matchedUser.photoUrl,
      lastMessage: welcomeMessage,
      messages: [welcomeMessage], // Initialize with welcome message
    );
  }
}
