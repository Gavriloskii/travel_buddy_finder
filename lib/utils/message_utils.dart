import 'package:travel_buddy_finder/models/message.dart';
import 'package:travel_buddy_finder/models/user_profile.dart';

class MessageUtils {
  /// Creates a welcome message for new matches.
  ///
  /// [senderId] is the ID of the message sender.
  /// [receiverId] is the ID of the message receiver.
  /// [matchedUser] is the UserProfile of the matched user.
  /// Returns a Message object containing the welcome message.
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
