import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function onItemTapped;

  HomePage({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('All Songs'),
          onTap: () {
            onItemTapped(0);
          },
        ),
        ListTile(
          title: Text('Albums'),
          onTap: () {
            // Implement navigation to Albums page if needed
          },
        ),
        ListTile(
          title: Text('Artists'),
          onTap: () {
            // Implement navigation to Artists page if needed
          },
        ),
        ListTile(
          title: Text('Favorites'),
          onTap: () {
            onItemTapped(3);
          },
        ),
        ListTile(
          title: Text('Playlists'),
          onTap: () {
            onItemTapped(1);
          },
        ),
      ],
    );
  }
}
