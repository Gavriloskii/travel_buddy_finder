import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_buddy_finder/theme/app_theme.dart';
import 'package:travel_buddy_finder/widgets/badge.dart'; // Import CustomBadge
import 'package:travel_buddy_finder/providers/message_provider.dart';

  /// A widget that displays a sidebar menu for navigation.
  class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  Widget _buildMenuContent(BuildContext context, {bool isCompact = false}) {
    final unreadCount = context.watch<MessageProvider>().unreadCount;
    final menuItems = [
      _MenuItem(0, Icons.explore, 'Home'),
      _MenuItem(1, Icons.chat_bubble, 'Messages', badge: unreadCount > 0 ? unreadCount : null),
      _MenuItem(2, Icons.shopping_bag, 'Marketplace'),
      _MenuItem(3, Icons.map_outlined, 'Itinerary'),
      _MenuItem(4, Icons.groups, 'Community'),
      _MenuItem(5, Icons.wb_sunny, 'Weather'),
      _MenuItem(6, Icons.edit_note, 'Journal'),
      _MenuItem(7, Icons.calendar_month, 'Events'),
    ];

    if (isCompact) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 16),
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
              child: Column(
                children: [
                  const Icon(
                    Icons.travel_explore,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: menuItems.map((item) => Tooltip(
                  message: item.title,
                  preferBelow: false,
                  child: InkWell(
                    onTap: () => onItemSelected(item.index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 56,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selectedIndex == item.index
                            ? AppTheme.primaryBlue.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          if (selectedIndex == item.index)
                            Positioned(
                              left: 0,
                              top: 8,
                              bottom: 8,
                              child: Container(
                                width: 3,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                              ),
                            ),
                          Stack(
                            children: [
                              Center(
                                child: Icon(
                                  item.icon,
                                  color: selectedIndex == item.index 
                                      ? AppTheme.primaryBlue 
                                      : Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                              if (item.badge != null)
                                CustomBadge(
                                  count: item.badge!,
                                  child: Icon(
                                    item.icon,
                                    color: selectedIndex == item.index 
                                        ? AppTheme.primaryBlue 
                                        : Colors.grey[600],
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const Divider(height: 1),
            Tooltip(
              message: 'Logout',
              preferBelow: false,
              child: InkWell(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
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
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel Buddy Finder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Find your next adventure partner',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ...menuItems.map((item) => _buildNavItem(context, item)),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _MenuItem item) {
    final isSelected = selectedIndex == item.index;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          Icon(
            item.icon,
            color: isSelected ? AppTheme.primaryBlue : Colors.grey[600],
          ),
          if (item.badge != null)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '${item.badge}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      selectedTileColor: AppTheme.primaryBlue.withOpacity(0.1),
      onTap: () {
        onItemSelected(item.index);
        if (MediaQuery.of(context).size.width < 600) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth < 900;

        if (isSmallScreen) {
          return Drawer(
            elevation: 2,
            child: _buildMenuContent(context),
          );
        }
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isMediumScreen ? 72 : 250,
          child: Material(
            elevation: 2,
            color: Theme.of(context).colorScheme.surface,
            child: _buildMenuContent(context, isCompact: isMediumScreen),
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final int index;
  final IconData icon;
  final String title;
  final int? badge;

  const _MenuItem(this.index, this.icon, this.title, {this.badge});
}
