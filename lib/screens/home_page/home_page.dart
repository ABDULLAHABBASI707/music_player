import 'package:flutter/material.dart';
import 'package:music_player/screens/home_page/artist_screen.dart';

class HomePage extends StatelessWidget {
  final Function(int) onItemTapped;

  HomePage({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 30.0), // Adjust the height to move the "HI" text down
            Text(
              'Hi',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Dhoom Machalay With mp3',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'What you want to hear today?',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  _buildGridItem(
                    title: 'All Songs',
                    imagePath:
                        'assets/allsong.jpg', // Replace with your image path
                    onTap: () => onItemTapped(0),
                  ),
                  _buildGridItem(
                    title: 'Playlists',
                    imagePath:
                        'assets/playlist.png', // Replace with your image path
                    onTap: () => onItemTapped(1),
                  ),
                  _buildGridItem(
                    title: 'Favorites',
                    imagePath:
                        'assets/favourite.png', // Replace with your image path
                    onTap: () => onItemTapped(3),
                  ),
                  _buildGridItem(
                      title: 'Artists',
                      imagePath:
                          'assets/artist.png', // Replace with your image path
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistScreen(
                              artistName:
                                  'Artist Name Example', // Replace with the actual artist name
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      {required String title,
      required String imagePath,
      required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 6.0,
                      color: Colors.black.withOpacity(0.8),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
