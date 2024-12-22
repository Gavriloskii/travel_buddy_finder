import 'package:flutter/material.dart';
import 'package:travel_buddy_finder/theme/app_theme.dart';
import 'package:travel_buddy_finder/widgets/sidebar_menu.dart';
import 'package:travel_buddy_finder/widgets/user_profile_card.dart';
import 'package:travel_buddy_finder/models/user_profile.dart';
import 'package:travel_buddy_finder/models/match_result.dart';
import 'package:travel_buddy_finder/models/slide_direction.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  List<UserProfile> _profiles = [];
  int _currentProfileIndex = 0;
  bool _isLoading = true;
  bool _isLikeHovered = false;
  bool _isDislikeHovered = false;
  String _loadingMessage = '';
  bool _isPageAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9,
    );
    _loadProfiles();
  }

  @override
  void dispose() {
    if (_profiles.isNotEmpty) {
      _pageController.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = 'Loading travel buddies...';
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      final profiles = UserProfile.getMockProfiles();
      print('Loaded ${profiles.length} profiles:');
      profiles.forEach((profile) => print('- ${profile.name} (${profile.personalityType})'));
      
      if (mounted) {
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profiles: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _profiles = [];
        });
      }
    }
  }

  void _handleLike() async {
    if (_profiles.isEmpty || _isPageAnimating) return;
    
    final currentProfile = _profiles[_currentProfileIndex];
    
    // Check for match
    final isMatch = await MatchResult.checkForMatch(currentProfile.id);
    
    if (mounted) {
      // Show match or like notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isMatch ? Icons.celebration : Icons.favorite,
                color: Colors.white
              ),
              const SizedBox(width: 8),
              Text(
                isMatch
                    ? 'It\'s a match with ${currentProfile.name}! 🎉'
                    : 'You liked ${currentProfile.name}! ✨'
              ),
            ],
          ),
          duration: Duration(seconds: isMatch ? 4 : 2),
          backgroundColor: isMatch ? Colors.purple : AppTheme.palmGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: isMatch ? SnackBarAction(
            label: 'Send Message',
            textColor: Colors.white,
            onPressed: () {
              setState(() => _selectedIndex = 1); // Switch to Messages tab
            },
          ) : null,
        ),
      );
    }
    
    await _showNextProfile(
      direction: SlideDirection.left,
      message: 'Finding your next perfect travel buddy... ✈️',
    );
  }

  void _handleDislike() async {
    if (_profiles.isEmpty || _isPageAnimating) return;
    
    final currentProfile = _profiles[_currentProfileIndex];
    
    // Log the current profile index
    print('Disliked ${currentProfile.name} at index $_currentProfileIndex');
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.close, color: Colors.white),
            const SizedBox(width: 8),
            Text('Passed on ${currentProfile.name} 👋'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    
    await _showNextProfile(
      direction: SlideDirection.right,
      message: 'Discovering more travel companions... 🌎',
    );
  }

  Future<void> _showNextProfile({
    required SlideDirection direction,
    required String message,
  }) async {
    if (_profiles.isEmpty || _isPageAnimating) return;
    
    final nextIndex = _currentProfileIndex + 1;
    if (nextIndex >= _profiles.length) {
      print('Reached end of profiles');
      return;
    }
    
    setState(() {
      _isPageAnimating = true;
      _loadingMessage = message;
    });
    
    try {
      print('Transitioning from profile ${_currentProfileIndex} to $nextIndex');
      await _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      
      if (mounted) {
        setState(() {
          _currentProfileIndex = nextIndex;
          print('Successfully transitioned to profile $nextIndex: ${_profiles[nextIndex].name}');
        });
      }
    } catch (e) {
      print('Error transitioning profiles: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPageAnimating = false;
        });
      }
    }
  }

  Widget _buildMatchingInterface() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              _loadingMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      );
    }

    if (_profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64,
              color: AppTheme.primaryBlue.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No profiles available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new travel buddies',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    bool isLastProfile = _currentProfileIndex == _profiles.length - 1;

    return Column(
      children: [
        Expanded(
          child: isLastProfile 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You\'ve seen all profiles!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later for more travel buddies',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
              : _profiles.isEmpty 
                  ? const SizedBox() 
                  : PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _profiles.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentProfileIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return UserProfileCard(
                          profile: _profiles[index],
                          onLike: _handleLike,
                          onDislike: _handleDislike,
                        );
                      },
                    ),
        ),
        if (!isLastProfile) Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isDislikeHovered = true),
                onExit: (_) => setState(() => _isDislikeHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 140,
                  transform: Matrix4.identity()..scale(_isDislikeHovered ? 1.05 : 1.0),
                  child: ElevatedButton.icon(
                    onPressed: _handleDislike,
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text('Dislike'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDislikeHovered ? Colors.red.withOpacity(0.1) : Colors.white,
                      foregroundColor: AppTheme.sunsetOrange,
                      elevation: _isDislikeHovered ? 4 : 2,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isLikeHovered = true),
                onExit: (_) => setState(() => _isLikeHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 140,
                  transform: Matrix4.identity()..scale(_isLikeHovered ? 1.05 : 1.0),
                  child: ElevatedButton.icon(
                    onPressed: _handleLike,
                    icon: const Icon(Icons.favorite, color: Colors.green),
                    label: const Text('Like'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLikeHovered ? Colors.green.withOpacity(0.1) : Colors.white,
                      foregroundColor: AppTheme.palmGreen,
                      elevation: _isLikeHovered ? 4 : 2,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
          SidebarMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.travel_explore,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Travel Buddy Finder',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
