import 'package:flutter/material.dart';
import 'package:travel_buddy_finder/widgets/sidebar_menu.dart';
import 'package:travel_buddy_finder/widgets/user_profile_card.dart';
import 'package:travel_buddy_finder/models/user_profile.dart';
import 'package:travel_buddy_finder/screens/sections/messages_screen.dart';
import 'package:travel_buddy_finder/screens/sections/marketplace_screen.dart';
import 'package:travel_buddy_finder/screens/sections/itinerary_screen.dart';
import 'package:travel_buddy_finder/screens/sections/community_forum_screen.dart';
import 'package:travel_buddy_finder/screens/sections/weather_screen.dart';
import 'package:travel_buddy_finder/screens/sections/journal_screen.dart';
import 'package:travel_buddy_finder/screens/sections/events_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late List<UserProfile> _profiles;
  int _currentProfileIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _profiles = UserProfile.getMockProfiles();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleLike() {
    // TODO: Implement match logic here
    print('Liked ${_profiles[_currentProfileIndex].name}');
    _showNextProfile();
  }

  void _handleDislike() {
    print('Disliked ${_profiles[_currentProfileIndex].name}');
    _showNextProfile();
  }

  void _showNextProfile() {
    if (_currentProfileIndex < _profiles.length - 1) {
      setState(() {
        _currentProfileIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Show "No more profiles" message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No more profiles available!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildMatchingInterface() {
    if (_profiles.isEmpty) {
      return const Center(
        child: Text('No profiles available'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _profiles.length,
            itemBuilder: (context, index) {
              return UserProfileCard(
                profile: _profiles[index],
                onLike: _handleLike,
                onDislike: _handleDislike,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedButton.icon(
                  onPressed: _handleDislike,
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text('Dislike'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: ElevatedButton.icon(
                  onPressed: _handleLike,
                  icon: const Icon(Icons.favorite, color: Colors.green),
                  label: const Text('Like'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildMatchingInterface();
      case 1:
        return const MessagesScreen();
      case 2:
        return const MarketplaceScreen();
      case 3:
        return const ItineraryScreen();
      case 4:
        return const CommunityForumScreen();
      case 5:
        return const WeatherScreen();
      case 6:
        return const JournalScreen();
      case 7:
        return const EventsScreen();
      default:
        return _buildMatchingInterface();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Persistent Sidebar
          SidebarMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Vertical Divider
          const VerticalDivider(width: 1),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor,
                  child: const Row(
                    children: [
                      Text(
                        'Travel Buddy Finder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
