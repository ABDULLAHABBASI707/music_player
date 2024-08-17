import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoritesPage extends StatelessWidget {
  final List<SongModel> favorites;
  final void Function(SongModel song) toggleFavorite;

  FavoritesPage({
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Favorite Songs',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/favourite.png', // Replace with your image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.shade100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/music_theme.png'),
                      ),
                      title: Center(
                        child: Text(
                          favorites[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          toggleFavorite(favorites[index]);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
