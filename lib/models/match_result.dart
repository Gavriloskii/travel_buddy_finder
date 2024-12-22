import 'package:travel_buddy_finder/models/user_profile.dart';
import 'package:travel_buddy_finder/models/message.dart';
import 'package:travel_buddy_finder/screens/sections/messages_screen.dart';

// Callback type for match notifications
typedef OnMatchCallback = void Function(UserProfile matchedProfile);

class MatchResult {
  final UserProfile? profile;
  final bool isMatch;
  final DateTime timestamp;

  MatchResult({
    required this.profile,
    required this.isMatch,
    required this.timestamp,
  });

  // Mock data for liked users (would be replaced with backend storage)
  static final Map<String, Set<String>> _likedUsers = {};

  // Add a like and check for mutual match
  static Future<MatchResult> addLike(
    String currentUserId,
    UserProfile likedProfile,
    OnMatchCallback onMatch,
  ) async {
    // Initialize set if not exists
    _likedUsers[currentUserId] ??= {};
    _likedUsers[likedProfile.id] ??= {};

    // Add like
    _likedUsers[currentUserId]!.add(likedProfile.id);

    // For testing: Simulate the other user liking back (70% chance)
    if (DateTime.now().millisecondsSinceEpoch % 100 < 70) {
      _likedUsers[likedProfile.id]!.add(currentUserId);
    }

    // Check if mutual like exists
    bool isMutualMatch = _likedUsers[likedProfile.id]?.contains(currentUserId) ?? false;

    if (isMutualMatch) {
      // Create empty conversation for the match
      final conversation = Conversation.createFromMatch(
        matchedUser: likedProfile,
        currentUserId: currentUserId,
      );
      
      // Add to MessagesScreen conversations
      MessagesScreen.mockConversations.insert(0, conversation);

      // Notify about the match
      onMatch(likedProfile);
    }

    return MatchResult(
      profile: likedProfile,
      isMatch: isMutualMatch,
      timestamp: DateTime.now(),
    );
  }

  // Check if users have matched
  static bool hasMatched(String user1Id, String user2Id) {
    return (_likedUsers[user1Id]?.contains(user2Id) ?? false) &&
           (_likedUsers[user2Id]?.contains(user1Id) ?? false);
  }

  // For backward compatibility with existing code
  static Future<bool> checkForMatch(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Return random match result (30% chance of match)
    return DateTime.now().millisecondsSinceEpoch % 100 < 30;
  }
}
