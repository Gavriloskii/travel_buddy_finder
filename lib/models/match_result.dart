import 'package:travel_buddy_finder/models/user_profile.dart';

class MatchResult {
  final UserProfile? profile;
  final bool isMatch;
  final DateTime timestamp;

  MatchResult({
    required this.profile,
    required this.isMatch,
    required this.timestamp,
  });

  // TODO: In the future, this will be replaced with an API call
  static Future<bool> checkForMatch(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Return random match result (30% chance of match)
    return DateTime.now().millisecondsSinceEpoch % 100 < 30;
  }
}
