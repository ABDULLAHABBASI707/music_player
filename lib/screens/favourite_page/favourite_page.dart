import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoritesPage extends StatelessWidget {
  final List<SongModel> favorites;
  final Function toggleFavorite;

  FavoritesPage({
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(favorites[index].title),
          subtitle: Text(favorites[index].artist ?? 'Unknown Artist'),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () => toggleFavorite(favorites[index]),
          ),
        );
      },
    );
  }
}
