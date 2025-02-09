import 'package:flutter/material.dart';

import '../../models/chatroom.dart';
import '../../models/user.dart';
import '../../services/chat_service.dart';
import '../../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatService _chatService = ChatService();
  final UserService _userService = UserService();
  List<Chatroom> _chatrooms = [];
  late User _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await _userService.getAuthToken();
      _currentUser = await _userService.getUserProfile();

      final chats = await _chatService.getChatsForUser(
        _currentUser.id,
        _userService.authToken!,
      );
      // print('Chats: $chats');

      setState(() {
        _chatrooms = chats.map((chat) => Chatroom.fromJson(chat)).toList();
        // print('Chatrooms: $_chatrooms');
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _chatrooms.length,
              itemBuilder: (context, index) {
                final chat = _chatrooms[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      chat.isGroupChat
                          ? 'https://via.placeholder.com/150'
                          : (_currentUser.profileImageUrl ??
                              'https://via.placeholder.com/150'),
                    ),
                  ),
                  title: Text(chat.name ?? 'Unnamed Chat'), // Handle null names
                  subtitle: const Text('Last message here...'),
                  onTap: () {
                    // Debug: Print the chatroom object as JSON
                    // print('Debugging Chatroom: ${jsonEncode(chat.toJson())}');

                    // Navigate to the chat screen with the chatroom as an argument
                    Navigator.pushNamed(context, '/chat', arguments: chat);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          Navigator.pushNamed(context, '/group-list');
        },
      ),
    );
  }
}


