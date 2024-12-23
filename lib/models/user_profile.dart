import 'package:travel_buddy_finder/utils/profile_utils.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String photoUrl;
  final List<String> interests;
  final String personalityType;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.photoUrl,
    required this.interests,
    required this.personalityType,
  });

  // Mock data generator
  static List<UserProfile> getMockProfiles() {
    return ProfileUtils.generateMockProfiles();
  }
}
