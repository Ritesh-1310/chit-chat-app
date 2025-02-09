import 'package:flutter/material.dart';
import '../../models/chatroom.dart';
import '../../services/socket_service.dart';
import '../../services/user_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService _socketService = SocketService();
  final UserService _userService = UserService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late Chatroom _chatroom;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _initializeChat);
  }

  Future<void> _initializeChat() async {
    try {
      final args = ModalRoute.of(context)?.settings.arguments as Chatroom?;
      if (args == null) {
        throw Exception("No chatroom data passed to ChatScreen.");
      }

      debugPrint("Chatroom data: ${args.toString()}");

      setState(() {
        _chatroom = args;
        _isLoading = false;
      });

      final user = await _userService.getUserProfile();

      _socketService.connectAndSignin(user.id);

      // Listen for messages
      debugPrint("Listening for messages...");
      _socketService.listenToMessages((msg) async {
        debugPrint("Received message: $msg");

        // Validate the message belongs to the current chatroom
        if (msg['chatroomId'] == _chatroom.id) {
          final currentUser =
              await _userService.getUserProfile(); // Fetch the current user

          // Ignore messages sent by the current user to avoid duplication
          if (msg['senderId'] == currentUser.id) {
            debugPrint("Ignoring self-sent message.");
            return;
          }

          debugPrint("Message belongs to current chatroom. Adding to UI.");

          setState(() {
            _messages.add({
              'sender': msg['senderName'] ?? 'Unknown',
              'content': msg['content'] ?? '',
            });
          });

          debugPrint("Updated messages: $_messages");
        } else {
          debugPrint(
              "Message does not belong to the current chatroom. Ignoring.");
        }
      });
    } catch (error) {
      debugPrint("Error initializing chat: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load chatroom data.")),
      );
    }
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) {
      debugPrint("Message content is empty. Skipping send.");
      return;
    }

    try {
      debugPrint("Sending message: $content");

      setState(() {
        _messages.add({
          'sender': 'You',
          'content': content,
        });
      });

      _messageController.clear();

      final currentUser = await _userService.getUserProfile();

      // Send message to all participants
      final participants = _chatroom.participants;

      // Emit the message to all participants
      _socketService.sendMessageToAll(
          participants, _chatroom.id, currentUser.id, content);

      debugPrint("Message sent to server: $content");
    } catch (error) {
      debugPrint("Error sending message: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send the message.")),
      );
    }
  }

  @override
  void dispose() {
    _socketService.disconnect(); // Disconnect from the socket server
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_chatroom.name ?? "Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser = message['sender'] == 'You';

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['content'] ?? '',
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
