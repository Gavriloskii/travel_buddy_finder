import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';
import '../../models/match_result.dart';
import '../../models/user_profile.dart';
import '../../theme/app_theme.dart';
import '../../providers/message_provider.dart';
import '../chat/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  // Static variable to persist selected conversation
  static Conversation? persistedConversation;
  
  // Mock data for conversations
  // Conversations will be added dynamically when matches occur
  static final List<Conversation> mockConversations = [];

  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Key for the scaffold to show snackbars
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Simulate matches for testing
  void _simulateMatch() async {
    final mockProfiles = UserProfile.getMockProfiles();
    if (mockProfiles.isEmpty) return;

    // Get a random profile
    final randomProfile = mockProfiles[DateTime.now().millisecondsSinceEpoch % mockProfiles.length];
    
    // Simulate mutual like
    await MatchResult.addLike(
      'currentUser',
      randomProfile,
      (matchedProfile) {
        // Show match notification
        _showMatchNotification(matchedProfile);
        // Refresh the screen
        setState(() {});
      },
    );
  }

  // Simulate receiving a new message
  void _simulateNewMessage() {
    if (MessagesScreen.mockConversations.isEmpty) return;

    final conversation = MessagesScreen.mockConversations[0];
    final newMessage = Message(
      id: DateTime.now().toString(),
      senderId: conversation.userId,
      receiverId: 'currentUser',
      content: 'Hey! Just checking in. How\'s your travel planning going?',
      timestamp: DateTime.now(),
    );

    setState(() {
      conversation.messages.add(newMessage);
    });

    // Add unread message to provider
    context.read<MessageProvider>().addMessage(newMessage);
  }

  // Show match notification
  void _showMatchNotification(UserProfile matchedProfile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "It's a match! You and ${matchedProfile.name} can now chat!",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryBlue,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Start Chat',
          textColor: Colors.white,
          onPressed: () {
            // Find the conversation for this match
            final conversation = MessagesScreen.mockConversations.firstWhere(
              (conv) => conv.userId == matchedProfile.id,
              orElse: () => throw Exception('Conversation not found'),
            );
            _handleConversationSelected(conversation);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize state from persisted conversation
    selectedConversation = MessagesScreen.persistedConversation;
  }

  Conversation? selectedConversation;

  void _handleConversationSelected(Conversation conversation) {
    setState(() {
      selectedConversation = conversation;
      // Update persisted conversation
      MessagesScreen.persistedConversation = conversation;
    });
  }

  void _handleBackToList() {
    setState(() {
      selectedConversation = null;
      // Clear persisted conversation
      MessagesScreen.persistedConversation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedConversation != null) {
      return WillPopScope(
        onWillPop: () async {
          _handleBackToList();
          return false;
        },
        child: ChatScreen(
          conversation: selectedConversation!,
          onClose: _handleBackToList,
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppTheme.primaryBlue,
        actions: [
          // Test button to simulate new message
          IconButton(
            icon: const Icon(Icons.message),
            tooltip: 'Simulate New Message',
            onPressed: _simulateNewMessage,
          ),
          // Test button to simulate matches
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Simulate Match',
            onPressed: _simulateMatch,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: MessagesScreen.mockConversations.length,
        itemBuilder: (context, index) {
          final conversation = MessagesScreen.mockConversations[index];
          return ConversationTile(
            conversation: conversation,
            onTap: () => _handleConversationSelected(conversation),
          );
        },
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
        foregroundImage: NetworkImage(conversation.userProfilePic),
        onForegroundImageError: (_, __) {},
        child: Icon(
          Icons.person,
          color: AppTheme.primaryBlue,
          size: 30,
        ),
        radius: 25,
      ),
      title: Text(
        conversation.userName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        conversation.lastMessage.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: !conversation.lastMessage.isRead && 
                     conversation.lastMessage.senderId != 'currentUser' 
              ? FontWeight.bold 
              : FontWeight.normal,
        ),
      ),
      trailing: Text(
        _formatTimestamp(conversation.lastMessage.timestamp),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
