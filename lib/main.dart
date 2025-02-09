import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Group Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(), 
        '/chat': (context) => const ChatScreen(),
        // '/profile': (context) => UserProfile(),
        // '/group-list': (context) => GroupList(),
        // '/group-chat': (context) => GroupChatScreen(),
      },
    );
  }
}



/*
Folder Structure for WhatsApp like UI

lib/
├── main.dart
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── group_list.dart
│   │   └── user_profile.dart
│   ├── chat/
│   │   ├── chat_screen.dart
│   │   └── widgets/ (contains chat-specific widgets)
│   ├── group/
│   │   └── group_chat_screen.dart
├── services/
│   ├── user_service.dart
│   ├── chat_service.dart
│   ├── group_service.dart
│   ├── message_service.dart
│   └── socket_service.dart
├── models/
│   ├── user.dart
│   ├── message.dart
│   ├── chatroom.dart
│   └── group.dart
├── utils/
│   └── constants.dart


*/