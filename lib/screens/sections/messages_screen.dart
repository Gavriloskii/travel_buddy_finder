import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../theme/app_theme.dart';
import '../chat/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  // Static variable to persist selected conversation
  static Conversation? persistedConversation;
  
  // Mock data for conversations
  static final List<Conversation> mockConversations = [
    Conversation(
      id: '1',
      userId: 'user1',
      userName: 'John Doe',
      userProfilePic: 'https://ui-avatars.com/api/?name=John+Doe&background=random',
      lastMessage: Message(
        id: 'm1',
        senderId: 'user1',
        receiverId: 'currentUser',
        content: 'Hey, want to meet up in Paris?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ),
    Conversation(
      id: '2',
      userId: 'user2',
      userName: 'Jane Smith',
      userProfilePic: 'https://ui-avatars.com/api/?name=Jane+Smith&background=random',
      lastMessage: Message(
        id: 'm2',
        senderId: 'currentUser',
        receiverId: 'user2',
        content: 'The Louvre was amazing!',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ),
    // TODO: Replace with real data from backend
  ];

  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppTheme.primaryBlue,
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
