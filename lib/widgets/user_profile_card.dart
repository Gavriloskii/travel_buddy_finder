import 'package:flutter/material.dart';
import 'package:travel_buddy_finder/theme/app_theme.dart';
import '../models/user_profile.dart';

class UserProfileCard extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const UserProfileCard({
    super.key,
    required this.profile,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _showLikeOverlay = false;
  bool _showDislikeOverlay = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _handleLike() {
    setState(() => _showLikeOverlay = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showLikeOverlay = false);
        widget.onLike();
      }
    });
  }

  void _handleDislike() {
    setState(() => _showDislikeOverlay = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showDislikeOverlay = false);
        widget.onDislike();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final horizontalMargin = isSmallScreen ? 12.0 : 24.0;
        final verticalMargin = isSmallScreen ? 8.0 : 16.0;
        final bottomPadding = isSmallScreen ? 16.0 : 24.0;
        final overlayIconSize = isSmallScreen ? 80.0 : 120.0;
        
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalMargin,
                      vertical: verticalMargin,
                    ),
                    height: MediaQuery.of(context).size.height * (isSmallScreen ? 0.6 : 0.7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 3,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Profile Image
                          widget.profile.photoUrl.startsWith('http')
                              ? Image.network(
                                  widget.profile.photoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppTheme.primaryBlue.withOpacity(0.1),
                                    child: Icon(
                                      Icons.travel_explore,
                                      size: isSmallScreen ? 60 : 100,
                                      color: AppTheme.primaryBlue.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: AppTheme.primaryBlue.withOpacity(0.1),
                                  child: Icon(
                                    Icons.travel_explore,
                                    size: isSmallScreen ? 60 : 100,
                                    color: AppTheme.primaryBlue.withOpacity(0.5),
                                  ),
                                ),
                          // Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),
                          // Like/Dislike Overlays
                          if (_showLikeOverlay)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: overlayIconSize,
                                ),
                              ),
                            ),
                          if (_showDislikeOverlay)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: overlayIconSize,
                                ),
                              ),
                            ),
                          // Profile Info
                          Positioned(
                            left: horizontalMargin,
                            right: horizontalMargin,
                            bottom: bottomPadding,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${widget.profile.name}, ${widget.profile.age}',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen ? 20 : 24,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 8 : 12,
                                        vertical: isSmallScreen ? 4 : 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryBlue.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        widget.profile.personalityType,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen ? 12 : 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallScreen ? 8 : 16),
                                Text(
                                  widget.profile.bio,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                  maxLines: isSmallScreen ? 2 : 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: isSmallScreen ? 12 : 20),
                                Wrap(
                                  spacing: isSmallScreen ? 6 : 10,
                                  runSpacing: isSmallScreen ? 6 : 10,
                                  children: widget.profile.interests.map((interest) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 8 : 12,
                                      vertical: isSmallScreen ? 4 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      interest,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    ),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
