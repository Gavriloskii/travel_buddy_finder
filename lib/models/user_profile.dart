class UserProfile {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String photoUrl;
  final List<String> interests;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.photoUrl,
    required this.interests,
  });

  // Mock data generator
  static List<UserProfile> getMockProfiles() {
    return [
      UserProfile(
        id: '1',
        name: 'Sarah Chen',
        age: 26,
        bio: 'Adventure seeker passionate about mountain climbing and photography. Looking for travel buddies for hiking expeditions!',
        photoUrl: 'https://example.com/sarah.jpg',
        interests: ['Hiking', 'Photography', 'Mountain Climbing'],
      ),
      UserProfile(
        id: '2',
        name: 'James Wilson',
        age: 30,
        bio: 'Food enthusiast and cultural explorer. Love discovering local cuisines and hidden gems in new cities.',
        photoUrl: 'https://example.com/james.jpg',
        interests: ['Food', 'Culture', 'City Exploration'],
      ),
      UserProfile(
        id: '3',
        name: 'Emma Rodriguez',
        age: 28,
        bio: 'Digital nomad and beach lover. Interested in sustainable travel and meeting like-minded travelers.',
        photoUrl: 'https://example.com/emma.jpg',
        interests: ['Beach', 'Sustainable Travel', 'Remote Work'],
      ),
      UserProfile(
        id: '4',
        name: 'Alex Kim',
        age: 25,
        bio: 'Backpacker with a passion for street photography and local markets. Always up for spontaneous adventures!',
        photoUrl: 'https://example.com/alex.jpg',
        interests: ['Backpacking', 'Photography', 'Local Markets'],
      ),
    ];
  }
}
