import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../utils/constants.dart';

class SocketService {
  IO.Socket? _socket; // Change to nullable type

  // Establish a connection to the socket server
  void connectAndSignin(String userId) {
    if (_socket != null && _socket!.connected) {
      print("Socket already connected.");
      return;
    }

    _socket = IO.io(
      SOCKET_URL,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .disableAutoConnect() // Disable auto-connect
          .build(),
    );

    // Handle connection
    _socket!.onConnect((_) {
      print('Connected to WebSocket');
      // Emit signin event after connecting
      _socket!.emit('signin', userId);
    });

    // Handle disconnection
    _socket!.onDisconnect((_) => print('Disconnected from WebSocket'));

    // Handle connection errors
    _socket!.onError((err) => print('Socket error: $err'));

    // Listen for incoming messages
    _socket!.on('message', (msg) => _onMessage(msg));
    _socket!.on('typing', (data) => _onTyping(data));
    _socket!.on('stop-typing', (data) => _onStopTyping(data));
    _socket!.on('online-users', (users) => _onOnlineUsers(users));
    _socket!.on('message-read', (data) => _onMessageRead(data));

    // Connect to the socket server
    _socket!.connect();
  }

  // Listen to messages
  void listenToMessages(Function(dynamic) onMessageReceived) {
    if (_socket == null) {
      print("Socket is not connected. Please initialize the socket first.");
      return;
    }
    _socket!.on('message', (msg) => onMessageReceived(msg));
  }

  // Emit a "signin" event with user ID
  void signin(String userId) {
    if (_socket == null || !_socket!.connected) {
      print("Socket is not connected. Please connect first.");
      return;
    }
    _socket!.emit('signin', userId);
  }

  // Emit a "message" event to all participants in the chatroom
  void sendMessageToAll(List<String> participants, String chatroomId, String senderId, String content) {
    if (_socket == null || !_socket!.connected) {
      print("Socket is not connected. Please connect first.");
      return;
    }

    // Emit the message to the server to broadcast to all participants
    _socket!.emit('message', {
      'chatroomId': chatroomId,
      'senderId': senderId,
      'content': content,
      'participants': participants, // Send participants list
    });

    print("Message sent: $content");
  }

  // Emit a "typing" event
  void typing(String senderId, String receiverId) {
    if (_socket == null || !_socket!.connected) {
      print("Socket is not connected. Please connect first.");
      return;
    }
    _socket!.emit('typing', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  // Emit a "stop-typing" event
  void stopTyping(String senderId, String receiverId) {
    if (_socket == null || !_socket!.connected) {
      print("Socket is not connected. Please connect first.");
      return;
    }
    _socket!.emit('stop-typing', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  // Emit a "mark-as-read" event
  void markAsRead(String messageId, String receiverId) {
    if (_socket == null || !_socket!.connected) {
      print("Socket is not connected. Please connect first.");
      return;
    }
    _socket!.emit('mark-as-read', {
      'messageId': messageId,
      'receiverId': receiverId,
    });
  }

  // Emit a group message
  void sendGroupMessage(String roomId, String message) {
    if (_socket == null || !_socket!.connected) {
      print("Socket is not connected. Please connect first.");
      return;
    }
    _socket!.emit('group-message', {
      'roomId': roomId,
      'message': message,
    });
  }

  // Disconnect the socket
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null; // Reset socket
    }
  }

  // Private Handlers
  void _onMessage(dynamic msg) {
    print("New message: ${msg['content']}");
    // Handle incoming message: Update UI or perform necessary actions
  }

  void _onTyping(dynamic data) {
    print("${data['senderId']} is typing...");
  }

  void _onStopTyping(dynamic data) {
    print("${data['senderId']} stopped typing.");
  }

  void _onOnlineUsers(dynamic users) {
    print("Online users: $users");
  }

  void _onMessageRead(dynamic data) {
    print("Message ${data['messageId']} marked as read");
  }
}
