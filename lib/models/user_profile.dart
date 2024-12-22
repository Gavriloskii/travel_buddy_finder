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
    return [
      UserProfile(
        id: '1',
        name: 'Sarah Chen',
        age: 26,
        bio: 'Adventure seeker passionate about mountain climbing and photography. Looking for travel buddies for hiking expeditions in the Pacific Northwest!',
        photoUrl: 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
        interests: ['Hiking', 'Photography', 'Mountain Climbing', 'Camping'],
        personalityType: 'ENFP',
      ),
      UserProfile(
        id: '2',
        name: 'James Wilson',
        age: 30,
        bio: 'Food enthusiast and cultural explorer from London. Love discovering local cuisines and hidden gems in new cities. Currently planning a culinary tour of Southeast Asia!',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
        interests: ['Food Tourism', 'Cultural Events', 'City Exploration', 'Cooking Classes'],
        personalityType: 'ISFJ',
      ),
      UserProfile(
        id: '3',
        name: 'Emma Rodriguez',
        age: 28,
        bio: 'Digital nomad and beach lover based in Barcelona. Passionate about sustainable travel and eco-friendly adventures. Looking for travel companions for a Mediterranean sailing trip!',
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
        interests: ['Beach Life', 'Sustainable Travel', 'Sailing', 'Remote Work'],
        personalityType: 'INTJ',
      ),
      UserProfile(
        id: '4',
        name: 'Alex Kim',
        age: 25,
        bio: 'Street photographer and market enthusiast from Seoul. Always up for spontaneous adventures and local experiences. Planning a backpacking trip through South America!',
        photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
        interests: ['Street Photography', 'Local Markets', 'Backpacking', 'Food Adventures'],
        personalityType: 'ESTP',
      ),
      UserProfile(
        id: '5',
        name: 'Maya Patel',
        age: 27,
        bio: 'Yoga instructor and wellness traveler from Mumbai. Seeking fellow mindful travelers for retreat experiences and cultural immersion. Currently exploring ancient meditation sites!',
        photoUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
        interests: ['Wellness Travel', 'Yoga', 'Meditation', 'Cultural Immersion'],
        personalityType: 'INFJ',
      ),
    ];
  }
}
