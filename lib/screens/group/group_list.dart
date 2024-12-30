import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final List<Map<String, String>> groups = [
    {'name': 'Flutter Devs', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Family', 'image': 'https://via.placeholder.com/150'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(group['image']!),
            ),
            title: Text(group['name']!),
            onTap: () {
              Navigator.pushNamed(context, '/group-chat');
            },
          );
        },
      ),
    );
  }
}
